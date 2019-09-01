import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:carpool/core/models/division.dart';
import 'package:carpool/core/models/trip.dart';
import 'package:carpool/core/models/user.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class Api {
  // Base URL
  static final String key = "key=AIzaSyBnIoMebZjJICjYkgy3XAyBE9eo7motiLs";
  static final String base = "https://maps.googleapis.com/maps/api";
  static final String output = "json";
  static final String units = "metric";

  static final restApiBaseUrl = 'http://carpool.scu.co.id/api/';

  // Directions API
  Future<Map<String, dynamic>> fetchDirection(LatLng origin, LatLng destination,
      {List<LatLng> wayPoints}) async {
    String apiURL = base + "/directions/" + output + "?";
    LatLng wayPoint;

    apiURL += "origin=" +
        origin.latitude.toString() +
        "," +
        origin.longitude.toString();

    apiURL += "&";
    apiURL += "destination=" +
        destination.latitude.toString() +
        "," +
        destination.longitude.toString();

    if (wayPoints.length != 0) apiURL += "&waypoints=optimize:true";

    while (wayPoints.length > 0) {
      wayPoint = wayPoints.removeLast();
      apiURL += "|" +
          wayPoint.latitude.toString() +
          "," +
          wayPoint.longitude.toString();
    }
    apiURL += "&" + key;

    print(apiURL);
    http.Response response = await http.get(apiURL);
    return jsonDecode(response.body);
  }

  // used to decode polyline string
  List decodePoly(String poly) {
    var list = poly.codeUnits;
    var lList = new List();
    int index = 0;
    int len = poly.length;
    int c = 0;
    // repeating until all attributes are decoded
    do {
      var shift = 0;
      int result = 0;

      // for decoding value of one attribute
      do {
        c = list[index] - 63;
        result |= (c & 0x1F) << (shift * 5);
        index++;
        shift++;
      } while (c >= 32);
      // if value is negative then bitwise not the value
      if (result & 1 == 1) {
        result = ~result;
      }
      var result1 = (result >> 1) * 0.00001;
      lList.add(result1);
    } while (index < len);

    // adding to previous value as done in encoding
    for (var i = 2; i < lList.length; i++) lList[i] += lList[i - 2];

    return lList;
  }

  List<LatLng> convertToLatLng(List points) {
    List<LatLng> result = List<LatLng>();
    for (int i = 0; i < points.length; i++) {
      if (i % 2 != 0) result.add(LatLng(points[i - 1], points[i]));
    }
    return result;
  }

  // Distance Matrix API
  Future<Map<String, dynamic>> fetchDistanceMatrix(
      List<LatLng> origins, List<LatLng> destinations) async {
    String apiURL = base + "/distancematrix/" + output + "?";
    LatLng origin;
    LatLng destination;

    apiURL += "origins=";
    origin = origins.removeLast();
    apiURL += origin.latitude.toString() + "," + origin.longitude.toString();

    // Multi origin
    while (origins.length > 0) {
      origin = origins.removeLast();
      apiURL +=
          "|" + origin.latitude.toString() + "," + origin.longitude.toString();
    }

    apiURL += "&";
    apiURL += "destinations=";
    destination = destinations.removeLast();
    apiURL += destination.latitude.toString() +
        "," +
        destination.longitude.toString();

    // Multi destination
    while (destinations.length > 0) {
      destination = destinations.removeLast();
      apiURL += "|" +
          destination.latitude.toString() +
          "," +
          destination.longitude.toString();
    }

    apiURL += "&" + key;

    print(apiURL);
    http.Response response = await http.get(apiURL);
    return jsonDecode(response.body);
  }

  //WEB SERVICES

  Future<bool> register({
    String name,
    String email,
    String password,
    String phone,
    DateTime birth,
  }) async {
    String url = restApiBaseUrl + 'user/register';
    print(url);
    http.Response response = await http.post(
      url,
      headers: {"Content-Type": 'application/json'},
      body: jsonEncode({
        "name": name,
        "email": email,
        "password": password,
        "phone": phone,
        "birth": birth.toString(),
      }),
    );

    print('@Api.register: register status code ${response.statusCode}');
    if (response.statusCode == 200)
      return true;
    else
      return false;
  }

  Future<User> login(String email, String password) async {
    User user;
    String url =
        restApiBaseUrl + 'user/login?' + 'email=$email' + '&password=$password';
    print(url);
    http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      user = User.fromJson(jsonDecode(response.body));
      print('@Api.login: userId = ${user.id}');
      return user;
    } else {
      print('Status code: ${response.statusCode}');
      print('@Api.login: Login failed');
      return null;
    }
  }

  Future<bool> logout(String id) async {
    String url = restApiBaseUrl + 'user/logout?id=$id';
    http.Response response = await http.put(url);

    if (response.statusCode == 200) return true;
    return false;
  }

  Future<User> editProfile(User user, {File image}) async {
    String url = restApiBaseUrl + 'user/edit';
    String editImageUrl = restApiBaseUrl + 'user/profile/${user.id}';
    User changedUser;

    //set profile image
    if (image != null) {
      var stream =
          new http.ByteStream(DelegatingStream.typed(image.openRead()));
      // get file length
      var length = await image.length();
      //create uri
      var uri = Uri.parse(editImageUrl);
      // create multipart request
      var request = new http.MultipartRequest("PUT", uri);
      // multipart that takes file
      var multipartFile = new http.MultipartFile(
          'image_profile', stream, length,
          filename: basename(image.path));
      // add file to multipart
      request.files.add(multipartFile);
      // send
      var response = await request.send();
      print(response.statusCode);
      // listen for response
      response.stream.transform(utf8.decoder).listen((value) {
        print(value);
      });
    }

    http.Response response = await http.put(url, body: user.toJson());

    if (response.statusCode == 200) {
      changedUser = User.fromJson(jsonDecode(response.body));
      return changedUser;
    } else {
      print(
          '@Api.editProfile: http PUT failed with status code ${response.statusCode}');
      return null;
    }
  }

  Future<List<Division>> getDivisions() async {
    String url = restApiBaseUrl + 'division';
    List<Division> divisions = List<Division>();

    http.Response response = await http.get(url);

    print('@Api.getDivisions: status code ${response.statusCode}');
    print('@Api.getDivisions: response body =>');
    print(response.body);

    if (response.statusCode == 200) {
      for (var div in jsonDecode(response.body)) {
        divisions.add(Division.fromJson(div));
      }
      return divisions;
    } else {
      return [];
    }
  }

  Future<List<Trip>> getTripFor(String id) async {
    print('@Api.getTripFor: fetching trips for userId $id');
    List<Trip> trips = List<Trip>();
    String url = restApiBaseUrl + 'trip/user?_id=$id';
    http.Response response = await http.get(url);

    print('@Api.getTripFor: status code ${response.statusCode}');
    if (response.statusCode == 200) {
      print(response.body);
      for (var tripJson in jsonDecode(response.body)) {
        trips.add(Trip.fromJson(tripJson));
      }
      return trips;
    } else {
      return [];
    }
  }

  Future<Trip> getTripById(String tripId) async {
    String url = restApiBaseUrl + 'trip/detail?_id=$tripId';
    http.Response response = await http.get(url);

    if (response.statusCode == 200)
      return Trip.fromJson(jsonDecode(response.body));
    else
      return null;
  }

  Future<bool> sendOrder(Trip trip) async {
    String url = restApiBaseUrl + 'trip/create';
    String encodedTrip = jsonEncode(trip.toJson());
    print(encodedTrip);
    http.Response response = await http.post(url,
        headers: {"Content-Type": 'application/json'}, body: encodedTrip);

    print('@Api.sendOrder: response body =>');
    print(response.body);
    if (response.statusCode == 200) {
      return true;
    } else {
      print('@Api.sendOrder: error with status code ${response.statusCode}');
      return false;
    }
  }

  Future<bool> cancelOrder(String tripId) async {
    String url = restApiBaseUrl + 'user/trip/delete?id=$tripId';

    http.Response response = await http.delete(url);
    print(response.body);
    print('@Api.cancelOrder: status code ${response.statusCode}');
    if (response.statusCode == 200)
      return true;
    else
      return false;
  }
}
