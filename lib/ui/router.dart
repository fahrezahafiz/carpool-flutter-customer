import 'package:carpool/ui/views/all_view.dart';
import 'package:flutter/material.dart';
import 'package:place_picker/place_picker.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case 'register':
        return MaterialPageRoute(builder: (_) => RegisterView());
      case 'home':
        return MaterialPageRoute(builder: (_) => HomeView());
      case 'pick_destination':
        var category = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => PickDestinationView(category));
      case 'pick_origin':
        return MaterialPageRoute(builder: (_) => PickOriginView());
      case 'trip_summary':
        return MaterialPageRoute(builder: (_) => TripSummaryView());
      case 'order_later':
        return MaterialPageRoute(builder: (_) => OrderLaterView());
      case 'trip':
        var tripId = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => TripView(tripId));
      case 'placepicker':
        return MaterialPageRoute(
            builder: (_) =>
                PlacePicker('AIzaSyBnIoMebZjJICjYkgy3XAyBE9eo7motiLs'));
      default:
        return MaterialPageRoute(builder: (_) {
          return Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          );
        });
    }
  }
}
