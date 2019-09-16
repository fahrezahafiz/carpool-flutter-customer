import 'package:carpool/core/models/direction.dart';
import 'package:carpool/core/models/trip.dart';
import 'package:carpool/core/viewmodels/base_model.dart';
import 'package:carpool/core/services/trip_service.dart';
import 'package:carpool/locator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:place_picker/place_picker.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:carpool/core/services/api.dart';

class TripSummaryModel extends BaseModel {
  TripService _tripService = locator<TripService>();

  PanelController _panelController = PanelController();

  CameraPosition get userPosition => _tripService.userPosition;
  CameraPosition get defaultPosition => _tripService.defaultPosition;
  GoogleMapController get mapController => _tripService.mapController;
  LocationResult get origin => _tripService.origin;
  List<LocationResult> get destinations => _tripService.destinations;
  bool get isPrivate => _tripService.isPrivate;
  Set<Marker> get destinationMarkers => _tripService.markers;
  Direction get direction => _tripService.direction;
  PanelController get panelController => _panelController;
  String get category => _tripService.currentTrip.category;

  set setMapController(GoogleMapController controller) {
    _tripService.setMapController = controller;
    notifyListeners();
  }

  Future<void> init() async {}

  void moveToUserLocation() {
    _tripService.moveToUserLocation();
  }

  void setOrigin(LocationResult origin) {
    _tripService.setOrigin = origin;
    notifyListeners();
  }

  void removeDestination(int index) {
    _tripService.destinations.removeAt(index);
    notifyListeners();
  }

  void expandPanel() {
    _panelController.open();
  }

  void collapsePanel() {
    _panelController.close();
  }

  void togglePrivate(bool val) {
    _tripService.togglePrivate(val);
    print(
        '@TripSummaryModel.togglePrivate: isPrivate ? ${_tripService.currentTrip.isPrivate}');
    notifyListeners();
  }

  Future<String> sendOrder() async {
    setBusy(true);
    String tripId = await _tripService.sendOrder();
    setBusy(false);
    return tripId;
  }
}
