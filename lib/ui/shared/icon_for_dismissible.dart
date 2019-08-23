import 'package:flutter/material.dart';

class IconForDismissible extends StatelessWidget {
  final bool isLeft;
  final IconData icon;
  final Color backgroundColor;

  IconForDismissible({this.isLeft, this.icon, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: isLeft
          ? AlignmentDirectional.centerStart
          : AlignmentDirectional.centerEnd,
      color: this.backgroundColor,
      child: Padding(
        padding:
            isLeft ? EdgeInsets.only(left: 10) : EdgeInsets.only(right: 10),
        child: Icon(
          this.icon,
          color: Colors.white,
        ),
      ),
    );
  }
}
