import 'dart:async';
import 'package:carpool/core/models/user.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:carpool/core/models/direction.dart';
import 'package:carpool/core/models/trip.dart';
import 'package:carpool/core/services/all_service.dart';
import 'package:carpool/core/services/api.dart';
import 'package:carpool/core/services/trip_service.dart';
import 'package:carpool/core/services/authentication_service.dart';
import 'package:carpool/core/viewmodels/base_model.dart';
import 'package:carpool/locator.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:place_picker/place_picker.dart';

class TripModel extends BaseModel {
  Api _api = locator<Api>();
  TripService _tripService = locator<TripService>();
  AuthenticationService _authenticationService =
      locator<AuthenticationService>();

  double rating = 0;
  String feedbackMessage;

  PanelController _panelController = PanelController();
  Timer _periodic;
  Set<Polyline> _polyLines = Set<Polyline>();
  Set<Marker> _markers = Set<Marker>();

  PanelController get panelController => _panelController;
  Trip get trip => _tripService.currentTrip;
  Set<Polyline> get polyLines => _polyLines;
  Set<Marker> get markers => _markers;
  CameraPosition get userPosition => _tripService.userPosition;
  CameraPosition get defaultPosition => _tripService.defaultPosition;
  GoogleMapController get mapController => _tripService.mapController;
  Direction get direction => _tripService.direction;
  User get currentUser => _authenticationService.currentUser;

  set setMapController(GoogleMapController controller) {
    _tripService.setMapController = controller;
    notifyListeners();
  }

  set setRating(double rating) {
    this.rating = rating;
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
        if (trip.status == TripState.Finished) {
          stop();
        }
        notifyListeners();
        print('${trip.status}');
      } catch (e, stack) {
        print('periodic stopped because of:\n$e');
        print(stack);
        stop();
      }
    });
  }

  void moveToUserLocation() {
    _tripService.moveToUserLocation();
    notifyListeners();
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
        .animateCamera(CameraUpdate.newLatLngBounds(direction.bounds, 100));
    notifyListeners();
  }

  Future<bool> cancelOrder() async {
    bool cancelSuccess;
    cancelSuccess = await _api.cancelOrder(trip.id);
    return cancelSuccess;
  }

  void stop() => _periodic.cancel();

  Future<bool> sendFeedback() async {
    setBusy(true);
    bool sendSuccess = await _api.sendFeedback(
        idTrip: trip.id,
        idUser: currentUser.id,
        idDriver: trip.driver.id,
        rating: rating,
        message: feedbackMessage);
    setBusy(false);
    if (sendSuccess)
      _tripService.setCurrentTrip = await _api.getTripById(trip.id);
    notifyListeners();
    return sendSuccess;
  }
}
