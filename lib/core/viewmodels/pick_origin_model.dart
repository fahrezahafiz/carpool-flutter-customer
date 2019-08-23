import 'package:carpool/core/viewmodels/base_model.dart';
import 'package:carpool/locator.dart';
import 'package:carpool/core/services/trip_service.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:place_picker/place_picker.dart';
import 'package:carpool/core/models/direction.dart';

class PickOriginModel extends BaseModel {
  TripService _tripService = locator<TripService>();

  Set<Polyline> _polyLines = Set<Polyline>();

  CameraPosition get userPosition => _tripService.userPosition;
  CameraPosition get defaultPosition => _tripService.defaultPosition;
  GoogleMapController get mapController => _tripService.mapController;
  LocationResult get origin => _tripService.origin;
  Set<Marker> get markers => _tripService.markers;
  Direction get direction => _tripService.direction;

  Set<Polyline> get polyLines => _polyLines;

  set setMapController(GoogleMapController controller) {
    _tripService.setMapController = controller;
    notifyListeners();
  }

  Future<void> init() async {
    _polyLines.clear();
    if (origin != null) await getDirection();
  }

  void moveToUserLocation() {
    _tripService.moveToUserLocation();
  }

  Future<void> setOrigin(LocationResult origin) async {
    _tripService.setOrigin = origin;
    _polyLines.clear();
    await getDirection();
    notifyListeners();
  }

  Future<void> getDirection() async {
    await _tripService.getDirection();

    _polyLines.add(Polyline(
        polylineId: PolylineId(origin.latLng.toString()),
        points: direction.polyLinePoints,
        width: 4,
        color: Colors.blue));
    mapController
        .animateCamera(CameraUpdate.newLatLngBounds(direction.bounds, 50));
    notifyListeners();
  }
}
