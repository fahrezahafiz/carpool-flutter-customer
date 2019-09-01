import 'package:carpool/core/models/division.dart';
import 'package:carpool/core/viewmodels/register_model.dart';
import 'package:carpool/ui/shared/compact_button.dart';
import 'package:carpool/ui/shared/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:carpool/ui/views/base_view.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class RegisterView extends StatefulWidget {
  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BaseView<RegisterModel>(
      onModelReady: (model) => model.init(),
      builder: (context, model, child) => Scaffold(
        body: Form(
          key: _formKey,
          child: Center(
            child: model.isBusy
                ? CircularProgressIndicator()
                : ListView(
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
                        controller: model.name,
                        validator: (text) {
                          if (text.isEmpty) return 'Masukkan nama';
                          return null;
                        },
                        onSaved: (text) => model.name.text = text,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(18),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18)),
                          labelText: 'Nama',
                        ),
                      ),
                      UIHelper.vSpaceXSmall(),
                      TextFormField(
                        controller: model.email,
                        validator: (text) {
                          if (text.isEmpty) return 'Masukkan email';
                          return null;
                        },
                        onSaved: (text) => model.email.text = text,
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
                        controller: model.password,
                        obscureText: true,
                        validator: (text) {
                          if (text.isEmpty) return 'Masukkan password';
                          if (text.length < 8)
                            return 'Password minimal 8 karakter';
                          return null;
                        },
                        onSaved: (text) => model.password.text = text,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(18),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18)),
                          labelText: 'Password',
                        ),
                      ),
                      UIHelper.vSpaceXSmall(),
                      TextFormField(
                        controller: model.phone,
                        validator: (text) {
                          if (text.isEmpty) return 'Masukkan nomor HP';
                          if (!model.isNumeric(text))
                            return 'Nomor HP tidak boleh mengandung huruf';
                          return null;
                        },
                        onSaved: (text) => model.phone.text = text,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(18),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18)),
                          labelText: 'Nomor HP',
                        ),
                      ),
                      UIHelper.vSpaceXSmall(),
                      GestureDetector(
                        onTap: () {
                          showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1940),
                            lastDate: DateTime.now(),
                          ).then((date) {
                            if (date != null) model.setBirth = date;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                                color: Theme.of(context).primaryColor),
                          ),
                          child: Text(
                              model.birth == null
                                  ? 'Tanggal Lahir'
                                  : model.birth,
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 16)),
                        ),
                      ),
                      UIHelper.vSpaceXSmall(),
                      DropdownButtonFormField(
                        items: model.dummy.map((String names) {
                          return new DropdownMenuItem(
                              value: names,
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.star),
                                  Text(names),
                                ],
                              ));
                        }).toList(),
                        onChanged: (newValue) {
                          model.dummyValue = newValue;
                        },
                        value: model.dummyValue,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                          filled: true,
                          fillColor: Colors.grey[200],
                        ),
                      ),
                      UIHelper.vSpaceMedium(),
                      model.isBusy
                          ? Center(child: CircularProgressIndicator())
                          : RaisedButton(
                              elevation: 0,
                              highlightElevation: 1,
                              shape: StadiumBorder(),
                              padding: EdgeInsets.symmetric(vertical: 12),
                              color: Colors.blueGrey,
                              child: Text(
                                'REGISTER',
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
                                  model.register().then((success) {
                                    print('@RegisterView: success ? $success');
                                    if (success) Navigator.pop(context, true);
                                  });
                                }
                              },
                            ),
                      UIHelper.vSpaceMedium(),
                      Center(
                        child: CompactButton(
                          padding: EdgeInsets.all(8),
                          child: Text(
                            'Kembali ke login',
                            style: TextStyle(color: Colors.black45),
                          ),
                          onTap: () => Navigator.pop(context, false),
                        ),
                      ),
                      UIHelper.vSpaceMedium(),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
