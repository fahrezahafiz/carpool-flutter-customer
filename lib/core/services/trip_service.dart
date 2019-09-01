import 'dart:async';

import 'package:carpool/core/models/direction.dart';
import 'package:carpool/core/models/trip.dart';
import 'package:carpool/core/models/user.dart';
import 'package:carpool/core/services/api.dart';
import 'package:carpool/core/services/authentication_service.dart';
import 'package:carpool/locator.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:place_picker/place_picker.dart';

class TripService {
  static const apiKey = 'AIzaSyBnIoMebZjJICjYkgy3XAyBE9eo7motiLs';
  Api _api = locator<Api>();
  AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  Trip _currentTrip;
  GoogleMapController _mapController;
  CameraPosition _defaultPosition =
      CameraPosition(target: LatLng(-6.2088, 106.8456), zoom: 16);
  CameraPosition _userPosition;

  Set<Marker> _markers = Set<Marker>();
  Direction _direction = Direction();

  Trip get currentTrip => _currentTrip;
  CameraPosition get userPosition => _userPosition;
  CameraPosition get defaultPosition => _defaultPosition;
  GoogleMapController get mapController => _mapController;
  LocationResult get origin => _currentTrip.origin;
  List<LocationResult> get destinations => _currentTrip.destinations;
  bool get isPrivate => _currentTrip.isPrivate;
  Set<Marker> get markers => _markers;
  Direction get direction => _direction;
  User get currentUser => _authenticationService.currentUser;

  set setCurrentTrip(Trip trip) => _currentTrip = trip;

  set setMapController(GoogleMapController controller) =>
      _mapController = controller;

  set setOrigin(LocationResult origin) {
    _currentTrip.origin = origin;
    setOriginMarker(origin);
  }

  void initTrip(String category) => _currentTrip = Trip(category);

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
    for (LocationResult dest in destinations) {
      if (dest.latLng != finalDestination) wayPoints.add(dest.latLng);
    }

    Map<String, dynamic> result = await _api
        .fetchDirection(origin.latLng, finalDestination, wayPoints: wayPoints);
    _currentTrip.polyLine = result['routes'][0]['overview_polyline']['points'];
    _direction.routeAndBounds(
      encodedPoly: result['routes'][0]['overview_polyline']['points'],
      bounds: result['routes'][0]['bounds'],
    );
    _direction.distanceAndDuration(result['routes'][0]['legs']);
    sortDestinations(result['geocoded_waypoints']);
  }

  void sortDestinations(List<dynamic> wayPoints) {
    List<LocationResult> newDestinationList = List<LocationResult>();
    for (Map<String, dynamic> wayPoint in wayPoints) {
      try {
        LocationResult dest = _currentTrip.destinations
            .firstWhere((dest) => dest.placeId == wayPoint['place_id']);
        newDestinationList.add(dest);
      } catch (e) {
        print(
            '@TripService.sortDestinations: placeId ${wayPoint['place_id']} not found in destination List.');
      }
    }
    _currentTrip.destinations = newDestinationList;
  }

  Future<LatLng> getFinalDestinationLatLng() async {
    int max = 0;
    int index = 0;
    LocationResult finalDestination;
    String finalDestinationAddress;
    List<LatLng> destinationsLatLng = [];
    for (LocationResult dest in destinations)
      destinationsLatLng.add(dest.latLng);

    Map<String, dynamic> result =
        await _api.fetchDistanceMatrix([origin.latLng], destinationsLatLng);

    for (Map<String, dynamic> element in result['rows'][0]['elements']) {
      if (element['distance']['value'] > max) {
        max = element['distance']['value'];
        finalDestinationAddress = result['destination_addresses'][index];
      }
      ++index;
    }

    finalDestination = destinations
        .firstWhere((dest) => dest.formattedAddress == finalDestinationAddress);
    print(
        '@MapService.getFinalDestinationLatLng: finalDestination => ${finalDestination.name}\n${finalDestination.formattedAddress}. LatLng: ${finalDestination.latLng}');
    return finalDestination.latLng;
  }

  void addDestination(LocationResult destination, {String notes}) {
    _currentTrip.destinations.add(destination);
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
        marker.markerId.value ==
        _currentTrip.destinations[index].latLng.toString());
    _markers.removeWhere((marker) => marker.markerId == tmpMarker.markerId);
    _currentTrip.destinations.removeAt(index);
  }

  void togglePrivate(bool val) {
    _currentTrip.isPrivate = val;
  }

  Future<bool> sendOrder() async {
    _currentTrip.users.add({"_id": currentUser.id, "name": currentUser.name});
    _currentTrip.schedule = DateTime.now();
    _currentTrip.totalDistance = _direction.distance.toDouble();
    _currentTrip.totalTime = _direction.duration.toDouble();
    _currentTrip.bounds = _direction.bounds;
    bool sendSuccess = await _api.sendOrder(_currentTrip);
    return sendSuccess;
  }
}
