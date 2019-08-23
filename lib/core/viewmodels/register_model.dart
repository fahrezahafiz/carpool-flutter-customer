import 'package:carpool/core/viewmodels/base_model.dart';
import 'package:carpool/locator.dart';
import 'package:carpool/core/services/authentication_service.dart';
import 'package:flutter/widgets.dart';

class RegisterModel extends BaseModel {
  AuthenticationService _authService = locator<AuthenticationService>();
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController phone = TextEditingController();
  DateTime _birth;

  String get birth =>
      _birth == null ? null : _birth.toString().substring(0, 10);

  set setBirth(DateTime birthDate) {
    _birth = birthDate;
    notifyListeners();
  }

  Future<bool> register() async {
    setBusy(true);
    bool registerSuccess = await _authService.register(
      name: name.text,
      email: email.text,
      password: password.text,
      phone: phone.text,
      birth: _birth,
    );
    setBusy(false);
    print('@RegisterModel.register: registerSuccess ? $registerSuccess');
    return registerSuccess;
  }

  bool isNumeric(String str) {
    if (str == null) {
      return false;
    }
    return double.tryParse(str) != null;
  }
}
