import 'package:carpool/core/models/company.dart';
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
  List<Company> companies = List<Company>();
  Company _company;
  List<Division> divisions = List<Division>();
  Division _division;

  Company get company => _company;
  Division get division => _division;

  set setCompany(Company company) {
    _company = company;
    notifyListeners();
  }

  set setDivision(Division division) {
    _division = division;
    notifyListeners();
  }

  Future<void> init() async {
    setBusy(true);
    companies = await _api.getCompanies();
    divisions = await _api.getDivisions();
    setBusy(false);
  }

  Future<bool> register() async {
    setBusy(true);
    bool registerSuccess = await _authService.register(
      name: name.text,
      email: email.text,
      password: password.text,
      phone: phone.text,
      company: _company.idCompany,
      division: _division.idDivision,
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
