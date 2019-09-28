import 'package:carpool/core/models/user.dart';
import 'package:carpool/core/viewmodels/base_model.dart';
import 'package:carpool/locator.dart';
import 'package:carpool/core/services/authentication_service.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileModel extends BaseModel {
  AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  static final emailKey = 'email';
  static final passKey = 'password';

  User get currentUser => _authenticationService.currentUser;

  void init() {
    print('@EditProfileModel.init: init');
    name.text = currentUser.name;
    email.text = currentUser.email;
    phone.text = currentUser.phone;
  }

  Future<bool> editProfile() async {
    setBusy(true);
    SharedPreferences _pref = await SharedPreferences.getInstance();
    bool editSuccess = await _authenticationService.editProfile(
        name.text, email.text, phone.text);

    if (editSuccess) _pref.setString(emailKey, email.text);

    setBusy(false);

    return editSuccess;
  }

  bool isNumeric(String str) {
    if (str == null) {
      return false;
    }
    return double.tryParse(str) != null;
  }
}
