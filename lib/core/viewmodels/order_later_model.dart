import 'package:carpool/core/viewmodels/base_model.dart';
import 'package:flutter/material.dart';

class OrderLaterModel extends BaseModel {
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
}
