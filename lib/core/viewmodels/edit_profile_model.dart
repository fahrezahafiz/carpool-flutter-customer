import 'package:carpool/core/models/user.dart';
import 'package:carpool/core/viewmodels/base_model.dart';
import 'package:carpool/locator.dart';
import 'package:carpool/core/services/authentication_service.dart';
import 'package:flutter/widgets.dart';

class EditProfileModel extends BaseModel {
  AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();

  User get currentUser => _authenticationService.currentUser;

  void init() {
    print('@EditProfileModel.init: init');
    name.text = currentUser.name;
    email.text = currentUser.email;
    phone.text = currentUser.phone;
  }

  Future<bool> editProfile() async {
    setBusy(true);
    bool editSuccess = await _authenticationService.editProfile(
        name.text, email.text, phone.text);
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
