import 'package:carpool/core/viewmodels/base_model.dart';
import 'package:flutter/material.dart';

class OrderLaterModel extends BaseModel {
  DateTime _date = DateTime.now();
  TimeOfDay _time = TimeOfDay.now();

  DateTime get date => _date;
  TimeOfDay get time => _time;

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
}
