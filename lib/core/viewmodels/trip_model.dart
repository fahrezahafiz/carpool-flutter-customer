import 'dart:async';

import 'package:carpool/core/models/direction.dart';
import 'package:carpool/core/models/trip.dart';
import 'package:carpool/core/services/all_service.dart';
import 'package:carpool/core/services/api.dart';
import 'package:carpool/core/services/trip_service.dart';
import 'package:carpool/core/viewmodels/base_model.dart';
import 'package:carpool/locator.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:place_picker/place_picker.dart';

class TripModel extends BaseModel {
  Api _api = locator<Api>();
  TripService _tripService = locator<TripService>();

  Timer _periodic;
  Set<Polyline> _polyLines = Set<Polyline>();
  Set<Marker> _markers = Set<Marker>();

  Trip get trip => _tripService.currentTrip;
  Set<Polyline> get polyLines => _polyLines;
  Set<Marker> get markers => _markers;
  CameraPosition get userPosition => _tripService.userPosition;
  CameraPosition get defaultPosition => _tripService.defaultPosition;
  GoogleMapController get mapController => _tripService.mapController;
  Direction get direction => _tripService.direction;

  set setMapController(GoogleMapController controller) {
    _tripService.setMapController = controller;
    notifyListeners();
  }

  Future<void> init(String tripId) async {
    setBusy(true);
    _tripService.setCurrentTrip = await _api.getTripById(tripId);
    print('${trip.status}');
    setMarkers();
    await getDirection();
    setBusy(false);

    _periodic = Timer.periodic(Duration(seconds: 2), (time) async {
      try {
        print('tick ${time.tick}');
        _tripService.setCurrentTrip = await _api.getTripById(tripId);
        if (trip.status == TripState.FindingDriver && trip.nearbyDrivers > 0)
          print('Nearby drivers: ${trip.nearbyDrivers}');
        else if (trip.status == TripState.FindingDriver &&
            trip.nearbyDrivers == 0) print('No nearby drivers.');
        if (trip.status == TripState.Finished) stop();
        notifyListeners();
        print('${trip.status}');
      } catch (e) {
        print('periodic stopped because of:\n$e');
        stop();
      }
    });
  }

  void moveToUserLocation() {
    _tripService.moveToUserLocation();
  }

  void setMarkers() {
    //origin marker
    markers.add(Marker(
      infoWindow: InfoWindow(title: trip.origin.name),
      markerId: MarkerId('origin'),
      position: trip.origin.latLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    ));
    //destinations markers
    for (LocationResult dest in trip.destinations) {
      markers.add(Marker(
        infoWindow: InfoWindow(title: dest.name),
        markerId: MarkerId(dest.latLng.toString()),
        position: dest.latLng,
      ));
    }
    notifyListeners();
  }

  Future<void> getDirection() async {
    await _tripService.getDirection();

    _polyLines.add(Polyline(
        polylineId: PolylineId(trip.origin.latLng.toString()),
        points: direction.polyLinePoints,
        width: 4,
        color: Colors.blue));
    mapController
        .animateCamera(CameraUpdate.newLatLngBounds(direction.bounds, 50));
    notifyListeners();
  }

  void stop() => _periodic.cancel();
}
