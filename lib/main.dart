import 'package:carpool/core/viewmodels/root_model.dart';
import 'package:carpool/locator.dart';
import 'package:carpool/ui/router.dart';
import 'package:carpool/ui/views/base_view.dart';
import 'package:carpool/ui/views/home_view.dart';
import 'package:carpool/ui/views/login_view.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return OKToast(
      position: ToastPosition(align: Alignment.bottomCenter),
      textPadding: EdgeInsets.all(14),
      textStyle: TextStyle(fontFamily: 'Nunito', color: Colors.black54),
      backgroundColor: Colors.white70,
      radius: 100,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Carpool',
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            color: Colors.white,
            brightness: Brightness.light,
            iconTheme: IconThemeData(color: Colors.black87),
            elevation: 3,
            textTheme: TextTheme(
              title: TextStyle(
                fontFamily: 'Nunito',
                color: Colors.black87,
                fontSize: 18,
              ),
            ),
          ),
          fontFamily: 'Nunito',
          primarySwatch: Colors.blueGrey,
        ),
        home: RootView(),
        onGenerateRoute: Router.generateRoute,
      ),
    );
  }
}

class RootView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView<RootModel>(
      onModelReady: (model) => model.init(),
      builder: (context, model, child) {
        switch (model.state) {
          case AuthState.Uninitialized:
            return Splash();
          case AuthState.NotLoggedIn:
            return LoginView();
          case AuthState.LoggedIn:
            return HomeView();
          default:
            return Scaffold();
        }
      },
    );
  }
}

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(child: CircularProgressIndicator()),
    );
  }
}
