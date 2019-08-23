import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color textColor;
  final Color borderColor;

  ActionButton(this.text,
      {this.onPressed,
      this.borderColor = Colors.black12,
      this.textColor = Colors.black});

  @override
  Widget build(BuildContext context) {
    return OutlineButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      borderSide: BorderSide(color: borderColor),
      highlightedBorderColor: textColor,
      textColor: textColor,
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
