import 'dart:async';

import 'package:carpool/core/models/trip.dart';
import 'package:carpool/core/services/api.dart';
import 'package:carpool/core/viewmodels/base_model.dart';
import 'package:carpool/locator.dart';

class TripModel extends BaseModel {
  Api _api = locator<Api>();
  Trip _trip = Trip();
  Timer _periodic;

  Trip get trip => _trip;

  Future<void> init(String tripId) async {
    setBusy(true);
    _trip = await _api.getTripById(tripId);
    print('${_trip.status}');
    setBusy(false);
    _periodic = Timer.periodic(Duration(seconds: 2), (time) async {
      print('tick ${time.tick}');
      _trip = await _api.getTripById(tripId);
      if (_trip.status == TripState.Finished) stop();
      notifyListeners();
      print('${_trip.status}');
    });
    print('after periodic');
  }

  void stop() => _periodic.cancel();
}
