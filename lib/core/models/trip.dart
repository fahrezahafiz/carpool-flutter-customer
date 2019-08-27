import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:place_picker/place_picker.dart';

enum TripState { WaitingForApproval, FindingDriver, OnTheWay, Finished }

class Trip {
  String _id;
  String driverId;
  String driverName;
  String idVehicle;
  List<Map<String, dynamic>> users;
  TripState status;
  String category;
  LocationResult origin;
  List<LocationResult> destinations;
  DateTime schedule;
  double totalTime;
  double totalDistance;
  bool isPrivate;
  String polyLine;
  DateTime createdAt;
  int code;
  int nearbyDrivers;

  Trip()
      : destinations = [],
        users = [],
        isPrivate = false;

  String get id => _id;

  Trip.fromJson(Map<String, dynamic> json) {
    this._id = json['_id'];
    //this.driverId = json['driver']['id'] ?? '';
    //this.driverName = json['driver']['name'] ?? '';
    this.idVehicle = json['id_vehicle'];
    this.users = List<Map<String, dynamic>>();
    for (var user in json['users']) {
      this.users.add(user);
    }
    switch (json['status']) {
      case 'WAITING_FOR_APPROVAL':
        this.status = TripState.WaitingForApproval;
        break;
      case 'FINDING_DRIVER':
        this.status = TripState.FindingDriver;
        break;
      case 'ON_THE_WAY':
        this.status = TripState.OnTheWay;
        break;
      case 'FINISHED':
        this.status = TripState.Finished;
        break;
    }
    this.category = json['category'];
    this.origin = _locationResultFromJson(json['origin']);
    this.destinations = List<LocationResult>();
    for (var dest in json['destination']) {
      this.destinations.add(_locationResultFromJson(dest));
    }
    this.schedule =
        DateTime.fromMillisecondsSinceEpoch(json['schedule'] * 1000);
    int totalTimeInt = json['total_time'];
    this.totalTime = totalTimeInt.toDouble();
    int totalDistanceInt = json['total_distance'];
    this.totalDistance = totalDistanceInt.toDouble();
    this.isPrivate = json['is_private'];
    this.createdAt = DateTime.parse(json['created_at']);
    this.code = json['code'];
    this.nearbyDrivers = json['nearby_drivers'];
  }

  Map<String, dynamic> toJson() => {
        'users': users,
        //'status_trip': tripStateToString(status),
        'category': category,
        'origin': _locationResultToJson(origin),
        'destination': destinations.map((dest) {
          return _locationResultToJson(dest);
        }).toList(),
        'schedule': schedule.toString(),
        'total_time': totalTime,
        'total_distance': totalDistance,
        'is_private': isPrivate,
        'polyline': polyLine,
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
      case TripState.FindingDriver:
        return 'FINDING_DRIVER';
      case TripState.OnTheWay:
        return 'ON_THE_WAY';
      case TripState.Finished:
        return 'FINISHED';
      default:
        return 'UNKNOWN';
    }
  }
}
