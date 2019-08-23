import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final bool obscureText;
  final String validatorText;

  CustomTextField(
      {this.labelText,
      this.controller,
      this.obscureText = false,
      this.validatorText});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onSaved: (val) {
        controller.text = val;
        print('controller: $val');
      },
      validator: (val) {
        if (val.isEmpty) return validatorText;
        return null;
      },
      obscureText: this.obscureText,
      decoration: InputDecoration(
        labelText: this.labelText,
        contentPadding: EdgeInsets.all(16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
