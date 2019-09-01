import 'package:flutter/material.dart';
import 'package:carpool/ui/shared/ui_helper.dart';
import 'package:carpool/ui/shared/compact_button.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:carpool/core/viewmodels/root_model.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    UIHelper.init(context);
    final auth = Provider.of<RootModel>(context);
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Center(
          child: ListView(
            padding: EdgeInsets.symmetric(
                horizontal: UIHelper.safeBlockHorizontal * 12),
            children: <Widget>[
              UIHelper.vSpaceLarge(),
              Image.asset(
                'images/sigma.png',
                height: UIHelper.safeBlockVertical * 20,
              ),
              UIHelper.vSpaceMedium(),
              TextFormField(
                controller: _email,
                validator: (text) {
                  if (text.isEmpty) return 'Masukkan email';
                  return null;
                },
                onSaved: (text) => _email.text = text,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(18),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18)),
                  labelText: 'Email',
                ),
              ),
              UIHelper.vSpaceXSmall(),
              TextFormField(
                controller: _password,
                obscureText: true,
                validator: (text) {
                  if (text.isEmpty) return 'Masukkan password';
                  if (text.length < 8) return 'Password minimal 8 karakter';
                  return null;
                },
                onSaved: (text) => _password.text = text,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(18),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18)),
                  labelText: 'Password',
                ),
              ),
              UIHelper.vSpaceMedium(),
              auth.isBusy
                  ? Center(child: CircularProgressIndicator())
                  : RaisedButton(
                      elevation: 0,
                      highlightElevation: 1,
                      shape: StadiumBorder(),
                      padding: EdgeInsets.symmetric(vertical: 12),
                      color: Colors.blueGrey,
                      child: Text(
                        'LOGIN',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                      ),
                      onPressed: () {
                        final form = _formKey.currentState;
                        form.save();
                        if (form.validate()) {
                          auth.login(_email.text, _password.text);
                        }
                      },
                    ),
              auth.errorMessage == null
                  ? UIHelper.vSpaceMedium()
                  : Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Center(
                          child: Text('Email atau password salah',
                              style: TextStyle(color: Colors.red))),
                    ),
              Center(
                child: CompactButton(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    'Buat akun baru',
                    style: TextStyle(color: Colors.black45),
                  ),
                  onTap: () async {
                    await Navigator.pushNamed(context, 'register')
                        .then((registerSuccess) {
                      if (registerSuccess) showToast('Register berhasil');
                    });
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
