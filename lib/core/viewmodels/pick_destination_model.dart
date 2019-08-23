import 'dart:async';
import 'package:carpool/core/viewmodels/base_model.dart';
import 'package:carpool/locator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:carpool/core/services/trip_service.dart';
import 'package:place_picker/place_picker.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class PickDestinationModel extends BaseModel {
  TripService _tripService = locator<TripService>();

  PanelController _panelController = PanelController();

  CameraPosition get userPosition => _tripService.userPosition;
  CameraPosition get defaultPosition => _tripService.defaultPosition;
  GoogleMapController get mapController => _tripService.mapController;
  List<LocationResult> get destinations => _tripService.destinations;
  Set<Marker> get markers => _tripService.markers;
  PanelController get panelController => _panelController;

  set setMapController(GoogleMapController controller) {
    _tripService.setMapController = controller;
    notifyListeners();
  }

  Future<void> init() async {
    print('PickDestinatioModel init...');
    setBusy(true);
    _tripService.initTrip();
    if (_tripService.userPosition == null) await _tripService.getUserLocation();
    print('Destinations cleared.');
    _tripService.clearMarkers();
    setBusy(false);
  }

  void moveToUserLocation() {
    _tripService.moveToUserLocation();
  }

  void addDestination(LocationResult destination) {
    _tripService.addDestination(destination);
    expandPanel();
    notifyListeners();
  }

  void changeDestination(LocationResult destination, int index) {
    _tripService.deleteDestination(index);
    _tripService.addDestination(destination);
    notifyListeners();
  }

  void deleteDestination(int index) {
    _tripService.deleteDestination(index);
    if (_tripService.destinations.length == 0) collapsePanel();
    notifyListeners();
  }

  void expandPanel() {
    _panelController.open();
  }

  void collapsePanel() {
    _panelController.close();
  }
}
