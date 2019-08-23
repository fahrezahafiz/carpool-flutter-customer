import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:place_picker/place_picker.dart';
import 'package:carpool/locator.dart';
import 'package:carpool/core/services/api.dart';
import 'package:carpool/core/models/direction.dart';

class MapService {
  static const apiKey = 'AIzaSyBnIoMebZjJICjYkgy3XAyBE9eo7motiLs';
  Api _api = locator<Api>();
  GoogleMapController _mapController;
  CameraPosition _defaultPosition =
      CameraPosition(target: LatLng(-6.2088, 106.8456), zoom: 16);
  CameraPosition _userPosition;

  LocationResult _origin;
  List<LocationResult> _destinations = List<LocationResult>();
  Set<Marker> _markers = Set<Marker>();
  Direction _direction = Direction();

  CameraPosition get userPosition => _userPosition;
  CameraPosition get defaultPosition => _defaultPosition;
  GoogleMapController get mapController => _mapController;
  LocationResult get origin => _origin;
  List<LocationResult> get destinations => _destinations;
  Set<Marker> get markers => _markers;
  Direction get direction => _direction;

  set setMapController(GoogleMapController controller) =>
      _mapController = controller;

  set setOrigin(LocationResult origin) {
    _origin = origin;
    setOriginMarker(origin);
  }

  Future<void> getUserLocation() async {
    print('@MapService: getting user location...');
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    _userPosition = new CameraPosition(
        target: LatLng(position.latitude, position.longitude), zoom: 16);
    print(
        '@MapService: userPosition = (${_userPosition.target.latitude}, ${_userPosition.target.longitude})');
  }

  void moveToUserLocation() {
    if (_userPosition != null)
      _mapController
          .animateCamera(CameraUpdate.newCameraPosition(_userPosition));
  }

  void addDestination(LocationResult destination, {String notes}) {
    _destinations.add(destination);
    addDestinationMarker(destination);
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(
                destination.latLng.latitude, destination.latLng.longitude),
            zoom: 17),
      ),
    );
  }

  void deleteDestination(int index) {
    Marker tmpMarker = _markers.firstWhere((marker) =>
        marker.markerId.value == _destinations[index].latLng.toString());
    _markers.removeWhere((marker) => marker.markerId == tmpMarker.markerId);
    _destinations.removeAt(index);
  }

  void clearDestinations() => _destinations = [];

  void clearOrigin() => _origin = null;

  void addDestinationMarker(LocationResult destination) {
    Marker newMarker = new Marker(
      infoWindow: InfoWindow(title: destination.name),
      markerId: MarkerId(destination.latLng.toString()),
      position: destination.latLng,
    );
    _markers.add(newMarker);
  }

  void setOriginMarker(LocationResult origin) {
    Marker newMarker = new Marker(
      infoWindow: InfoWindow(title: origin.name),
      markerId: MarkerId('origin'),
      position: origin.latLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    );
    _markers.removeWhere((marker) => marker.markerId.value == 'origin');
    _markers.add(newMarker);
  }

  void removeMarker(LocationResult place) {
    _markers.removeWhere(
        (marker) => marker.markerId.value == place.latLng.toString());
  }

  void clearMarkers() => _markers = <Marker>{};

  Future<void> getDirection() async {
    LatLng finalDestination = await getFinalDestinationLatLng();
    print(
        '@MapService.getDirection: Distance: ${_direction.distance}Duration: ${_direction.duration}');
    List<LatLng> wayPoints = [];
    for (LocationResult dest in _destinations) {
      if (dest.latLng != finalDestination) wayPoints.add(dest.latLng);
    }

    Map<String, dynamic> result = await _api
        .fetchDirection(_origin.latLng, finalDestination, wayPoints: wayPoints);
    _direction.routeAndBounds(
      encodedPoly: result['routes'][0]['overview_polyline']['points'],
      bounds: result['routes'][0]['bounds'],
    );
  }

  Future<LatLng> getFinalDestinationLatLng() async {
    int max = 0;
    int index = 0;
    LocationResult finalDestination;
    String finalDestinationAddress;
    List<LatLng> destinationsLatLng = [];
    for (LocationResult dest in _destinations)
      destinationsLatLng.add(dest.latLng);

    Map<String, dynamic> result =
        await _api.fetchDistanceMatrix([_origin.latLng], destinationsLatLng);

    for (Map<String, dynamic> element in result['rows'][0]['elements']) {
      if (element['distance']['value'] > max) {
        max = element['distance']['value'];
        finalDestinationAddress = result['destination_addresses'][index];
        _direction.distanceAndDuration(element);
        ++index;
      }
    }

    finalDestination = _destinations
        .firstWhere((dest) => dest.formattedAddress == finalDestinationAddress);
    print(
        '@MapService.getFinalDestinationLatLng: finalDestination => ${finalDestination.name}\n${finalDestination.formattedAddress}. LatLng: ${finalDestination.latLng}');
    return finalDestination.latLng;
  }
}
