import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:place_picker/place_picker.dart';
import 'package:carpool/core/models/feedback.dart';
import 'package:carpool/core/models/driver.dart';

enum TripState { WaitingForApproval, Denied, FindingDriver, OnTheWay, Finished }

class Trip {
  String _id;
  Driver driver;
  List<Map<String, dynamic>> users;
  TripState status;
  String _category;
  LocationResult origin;
  List<LocationResult> destinations;
  DateTime schedule;
  double totalTime;
  double totalDistance;
  bool isPrivate;
  String polyLine;
  LatLngBounds bounds;
  DateTime createdAt;
  int code;
  int nearbyDrivers;
  Feedback feedback;
  bool feedbackSent;

  Trip(String category)
      : destinations = [],
        users = [],
        this._category = category,
        isPrivate = category == 'sedan';

  String get id => _id;
  String get category => _getCategory();
  String get distanceText => _getDistanceText();
  String get timeText => _getTimeText();

  Trip.fromJson(Map<String, dynamic> json) {
    this._id = json['_id'];
    if (json['driver'] != null) {
      this.driver = Driver.fromTrip(json['driver']);
    }
    this.users = List<Map<String, dynamic>>();
    for (var user in json['users']) {
      this.users.add(user);
    }
    switch (json['status']) {
      case 'WAITING_FOR_APPROVAL':
        this.status = TripState.WaitingForApproval;
        break;
      case 'DENIED':
        this.status = TripState.Denied;
        break;
      case 'FINDING_DRIVER':
        this.status = TripState.FindingDriver;
        break;
      case 'ON_THE_WAY':
        this.status = TripState.OnTheWay;
        break;
      case 'FINISH':
        this.status = TripState.Finished;
        break;
    }
    this._category = json['category'];
    this.origin = _locationResultFromJson(json['origin']);
    this.destinations = List<LocationResult>();
    for (var dest in json['destination']) {
      this.destinations.add(_locationResultFromJson(dest));
    }
    this.schedule = DateTime.parse(json['schedule']);
    int totalTimeInt = json['total_time'];
    this.totalTime = totalTimeInt.toDouble();
    int totalDistanceInt = json['total_distance'];
    this.totalDistance = totalDistanceInt.toDouble();
    this.isPrivate = json['is_private'];
    this.createdAt = DateTime.parse(json['created_at']);
    this.code = json['code'];
    this.nearbyDrivers = json['nearby_drivers'];
    this.feedback = Feedback.fromJson(json['feedback']);
    print('@Trip.fromJson: feedback on trip =>\n');
    print(jsonEncode(feedback));
    this.feedbackSent = this.feedback.message.isNotEmpty;
    print('@Trip.fromJson: feedbackSent ? $feedbackSent');
  }

  Map<String, dynamic> toJson() => {
        'users': users,
        //'status_trip': tripStateToString(status),
        'category': _category,
        'origin': _locationResultToJson(origin),
        'destination': destinations.map((dest) {
          return _locationResultToJson(dest);
        }).toList(),
        'schedule': schedule.toString(),
        'total_time': totalTime,
        'total_distance': totalDistance,
        'is_private': isPrivate,
        'polyline': polyLine,
        'bounds': boundsToJson(bounds),
      };

  LocationResult _locationResultFromJson(Map<String, dynamic> location) {
    LocationResult result = LocationResult();
    result.name = location['name'];
    result.formattedAddress = location['address'];
    result.latLng =
        LatLng(location['lat_lng']['lat'], location['lat_lng']['lng']);
    result.placeId = location['place_id'];
    return result;
  }

  Map<String, dynamic> _locationResultToJson(LocationResult loc) => {
        'name': loc.name,
        'lat_lng': {'lat': loc.latLng.latitude, 'lng': loc.latLng.longitude},
        'address': loc.formattedAddress,
        'locality': loc.locality,
        'place_id': loc.placeId,
      };

  String tripStateToString(TripState state) {
    switch (state) {
      case TripState.WaitingForApproval:
        return 'WAITING_FOR_APPROVAL';
      case TripState.Denied:
        return 'DENIED';
      case TripState.FindingDriver:
        return 'FINDING_DRIVER';
      case TripState.OnTheWay:
        return 'ON_THE_WAY';
      case TripState.Finished:
        return 'FINISH';
      default:
        return 'UNKNOWN';
    }
  }

  Map<String, dynamic> boundsToJson(LatLngBounds bounds) {
    Map<String, dynamic> json = {
      'northeast': {
        'lat': bounds.northeast.latitude,
        'lng': bounds.northeast.longitude,
      },
      'southwest': {
        'lat': bounds.southwest.latitude,
        'lng': bounds.southwest.longitude,
      }
    };
    return json;
  }

  String _getDistanceText() {
    double distanceInKm = totalDistance / 1000;
    return distanceInKm.toStringAsFixed(1) + ' km';
  }

  String _getTimeText() {
    double durationInMins = totalTime / 60;
    return durationInMins.round().toString() + ' mins';
  }

  String _getCategory() {
    print('@Trip: _category = $_category');
    switch (_category) {
      case 'sedan':
        return 'Sedan';
      case 'mpvstandard':
        return 'MPV';
      case 'mpvvip':
        return 'MPV VIP';
      case 'minibus':
        return 'Minibus';
      default:
        return 'Unkown category';
    }
  }
}
