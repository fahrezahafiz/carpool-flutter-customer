import 'package:flutter/material.dart';

class BaseModel extends ChangeNotifier {
  bool _busy = false;

  bool get isBusy => _busy;

  void setBusy(bool val) {
    _busy = val;
    print('@ViewState busy: $_busy');
    notifyListeners();
    print('@BaseModel: listeners notified');
  }
}
