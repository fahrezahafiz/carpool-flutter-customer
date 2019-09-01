import 'package:flutter/material.dart';

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onConfirm;

  ConfirmDialog({this.title, this.content, this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Text(content),
      actions: <Widget>[
        FlatButton(
          child: Text('BATAL'),
          onPressed: () => Navigator.pop(context),
        ),
        FlatButton(
          child: Text('OK'),
          onPressed: () {
            onConfirm();
          },
        ),
      ],
    );
  }
}
