import 'dart:async';

import 'package:carpool/core/models/trip.dart';
import 'package:carpool/core/services/all_service.dart';
import 'package:carpool/core/services/api.dart';
import 'package:carpool/core/services/trip_service.dart';
import 'package:carpool/core/viewmodels/base_model.dart';
import 'package:carpool/locator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TripModel extends BaseModel {
  Api _api = locator<Api>();
  TripService _tripService = locator<TripService>();

  Trip _trip = Trip();
  Timer _periodic;
  Set<Polyline> _polyLines = Set<Polyline>();
  Set<Marker> _markers = Set<Marker>();

  Trip get trip => _trip;
  Set<Polyline> get polyLines => _polyLines;
  Set<Marker> get markers => _markers;
  CameraPosition get userPosition => _tripService.userPosition;
  CameraPosition get defaultPosition => _tripService.defaultPosition;
  GoogleMapController get mapController => _tripService.mapController;

  set setMapController(GoogleMapController controller) {
    _tripService.setMapController = controller;
    notifyListeners();
  }

  Future<void> init(String tripId) async {
    setBusy(true);
    _trip = await _api.getTripById(tripId);
    print('${_trip.status}');
    setBusy(false);

    _periodic = Timer.periodic(Duration(seconds: 2), (time) async {
      print('tick ${time.tick}');
      _trip = await _api.getTripById(tripId);
      if (_trip.status == TripState.FindingDriver && _trip.nearbyDrivers > 0)
        print('Nearby drivers: ${_trip.nearbyDrivers}');
      else if (_trip.status == TripState.FindingDriver &&
          _trip.nearbyDrivers == 0) print('No nearby drivers.');
      if (_trip.status == TripState.Finished) stop();
      notifyListeners();
      print('${_trip.status}');
    });
  }

  void viewRoute() {
    _markers = {};
    _polyLines = {};
    _markers.add(
      Marker(
        markerId: MarkerId(_trip.origin.placeId),
        position: _trip.origin.latLng,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ),
    );
    for (var dest in _trip.destinations) {
      _markers.add(
        Marker(
          markerId: MarkerId(dest.placeId),
          position: dest.latLng,
        ),
      );
    }
    notifyListeners();
  }

  void stop() => _periodic.cancel();
}
