import 'package:carpool/core/viewmodels/base_model.dart';
import 'package:carpool/locator.dart';
import 'package:carpool/core/services/authentication_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:carpool/core/models/user.dart';

enum AuthState { Uninitialized, NotLoggedIn, LoggedIn }

class RootModel extends BaseModel {
  static final emailKey = 'email';
  static final passKey = 'password';
  AuthenticationService _authService = locator<AuthenticationService>();
  AuthState _state = AuthState.Uninitialized;
  String _errorMessage;

  AuthState get state => _state;
  User get currentUser => _authService.currentUser;
  String get errorMessage => _errorMessage;

  Future<void> init() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    String email = _pref.getString(emailKey);
    String pass = _pref.getString(passKey);
    if (email != null && pass != null) {
      await login(email, pass);
      print(
          '@AuthService.initialCheck: saved login creds found. onto HomeView.');
    } else {
      _state = AuthState.NotLoggedIn;
      print(
          '@AuthService.initialCheck: no login creds found. onto RegisterView.');
    }
  }

  Future<void> login(String email, String password) async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    setBusy(true);

    bool loginSuccess = await _authService.login(email, password);
    if (loginSuccess) {
      _pref.setString(emailKey, email);
      _pref.setString(passKey, password);
      _state = AuthState.LoggedIn;
    } else {
      _errorMessage = 'Email atau password salah';
    }
    notifyListeners();
    setBusy(false);
  }

  Future<void> logout() async {
    setBusy(true);
    await _authService.logout(currentUser.id);
    _state = AuthState.NotLoggedIn;
    notifyListeners();
    setBusy(false);
  }
}
