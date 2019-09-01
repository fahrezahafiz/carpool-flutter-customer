import 'package:carpool/core/models/division.dart';
import 'package:carpool/core/services/api.dart';
import 'package:carpool/core/viewmodels/base_model.dart';
import 'package:carpool/locator.dart';
import 'package:carpool/core/services/authentication_service.dart';
import 'package:flutter/widgets.dart';

class RegisterModel extends BaseModel {
  Api _api = locator<Api>();
  AuthenticationService _authService = locator<AuthenticationService>();
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController phone = TextEditingController();
  Division _division = Division();
  DateTime _birth;
  List<Division> _divisions = [];

  String dummyValue = 'test';
  List<String> dummy = ['kips', 'hilmy', 'ican'];

  String get birth =>
      _birth == null ? null : _birth.toString().substring(0, 10);
  Division get division => _division;
  List<Division> get divisions => _divisions;

  set setBirth(DateTime birthDate) {
    _birth = birthDate;
    notifyListeners();
  }

  set setDivision(Division div) {
    _division = div;
    notifyListeners();
  }

  Future<void> init() async {
    setBusy(true);
    _divisions = await _api.getDivisions();
    setBusy(false);
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
