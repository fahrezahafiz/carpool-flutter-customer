import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:carpool/locator.dart';
import 'package:carpool/core/services/api.dart';

Api _api = locator<Api>();

class Direction {
  List<LatLng> polyLinePoints;
  LatLngBounds bounds;
  String distanceText;
  String durationText;
  int distance;
  int duration;

  Direction();

  void routeAndBounds({String encodedPoly, Map<String, dynamic> bounds}) {
    this.polyLinePoints = _api.convertToLatLng(_api.decodePoly(encodedPoly));

    //northeast bound
    LatLng northeast =
        LatLng(bounds['northeast']['lat'], bounds['northeast']['lng']);
    //southwest
    LatLng southwest =
        LatLng(bounds['southwest']['lat'], bounds['southwest']['lng']);
    this.bounds = LatLngBounds(southwest: southwest, northeast: northeast);
  }

  void distanceAndDuration(Map<String, dynamic> element) {
    this.distance = element['distance']['value'];
    this.distanceText = element['distance']['text'];

    this.duration = element['duration']['value'];
    this.durationText = element['duration']['text'];
  }
}
