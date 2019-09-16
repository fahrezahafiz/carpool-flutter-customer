import 'package:carpool/locator.dart';
import 'package:carpool/core/services/api.dart';
import 'package:carpool/core/models/user.dart';

class AuthenticationService {
  Api _api = locator<Api>();
  User _currentUser;

  User get currentUser => _currentUser;

  Future<bool> register({
    String name,
    String email,
    String password,
    String phone,
    DateTime birth,
    String company,
  }) async {
    bool registerSuccess = await _api.register(
      name: name,
      email: email,
      password: password,
      phone: phone,
      birth: birth,
      company: company,
    );
    return registerSuccess;
  }

  Future<bool> login(String email, String password) async {
    User user = await _api.login(email, password);
    _currentUser = user;
    bool loginSuccess = _currentUser != null;

    if (loginSuccess) {
      print('@AuthService.login: login success. returned $loginSuccess');
      return loginSuccess;
    } else {
      return loginSuccess;
    }
  }

  Future<bool> getUserInfo() async {
    String id = _currentUser.id;
    User user = await _api.getUserInfo(id);
    if (user != null) _currentUser = user;

    bool success = user != null;
    return success;
  }

  Future<bool> logout(String id) async {
    bool logoutSuccess = await _api.logout(id);
    return logoutSuccess;
  }
}
