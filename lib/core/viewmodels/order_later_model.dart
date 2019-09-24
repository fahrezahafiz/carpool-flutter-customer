import 'package:carpool/core/viewmodels/base_model.dart';
import 'package:flutter/material.dart';
import 'package:carpool/locator.dart';
import 'package:carpool/core/services/trip_service.dart';

class OrderLaterModel extends BaseModel {
  TripService _tripService = locator<TripService>();
  DateTime _date = DateTime.now();
  TimeOfDay _time = TimeOfDay.now();
  bool _isDinas = false;
  int duration = 1;

  DateTime get date => _date;
  TimeOfDay get time => _time;
  bool get isDinas => _isDinas;

  set setDate(DateTime date) {
    _date = date;
    print(_date.toString());
    notifyListeners();
  }

  set setTime(TimeOfDay time) {
    _time = time;
    print(_time.toString());
    notifyListeners();
  }

  void toggleDinas(bool val) {
    _isDinas = val;
    notifyListeners();
  }

  void addDuration() {
    if (duration < 7) duration++;
    notifyListeners();
  }

  void subtractDuration() {
    if (duration > 1) duration--;
    notifyListeners();
  }

  Future<String> orderLater() async {
    setBusy(true);
    DateTime schedule = DateTime(
        _date.year, _date.month, _date.day, _time.hour, _time.minute, 0, 0, 0);
    _tripService.currentTrip.schedule = schedule;
    String tripId = await _tripService.sendOrder();
    setBusy(false);
    print(
        '@OrderLaterModel.orderLater: book later with schedule: ${_tripService.currentTrip.schedule}');
    return tripId;
  }
}
