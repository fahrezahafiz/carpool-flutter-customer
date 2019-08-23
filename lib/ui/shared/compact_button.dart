import 'package:flutter/material.dart';

class CompactButton extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final Color splashColor;
  final VoidCallback onTap;
  final EdgeInsets padding;

  CompactButton(
      {this.child,
      this.backgroundColor = Colors.transparent,
      this.splashColor,
      this.onTap,
      this.padding = EdgeInsets.zero});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      child: InkWell(
        onTap: onTap,
        splashColor: splashColor,
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}
