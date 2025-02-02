import 'package:carpool/core/models/user.dart';
import 'package:carpool/core/services/authentication_service.dart';
import 'package:carpool/core/viewmodels/base_model.dart';
import 'package:carpool/locator.dart';

class AccountTabModel extends BaseModel {
  AuthenticationService _authenticationService =
      locator<AuthenticationService>();

  User get currentUser => _authenticationService.currentUser;

  void init() async {
    setBusy(true);
    print('init account tab model');
    await _authenticationService.getUserInfo();
    setBusy(false);
  }

  Future<void> logout() async {}
}
