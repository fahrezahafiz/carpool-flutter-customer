import 'package:carpool/core/viewmodels/base_model.dart';
import 'package:carpool/locator.dart';
import 'package:carpool/core/services/authentication_service.dart';

class LoginModel extends BaseModel {
  AuthenticationService _authenticationService =
      locator<AuthenticationService>();

  String _errorMessage;

  String get errorMessage => _errorMessage;

  Future<void> login(String email, String password) async {
    setBusy(true);
    bool loginSuccess = await _authenticationService.login(email, password);
    if (!loginSuccess) {
      _errorMessage = 'Email atau password salah';
    }
    notifyListeners();
    setBusy(false);
  }
}
