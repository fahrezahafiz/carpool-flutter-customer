import 'package:flutter/material.dart';

class CustomFAB extends StatelessWidget {
  final AlignmentGeometry alignment;
  final Widget child;
  final double elevation;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final VoidCallback onTap;

  CustomFAB(
      {this.child,
      this.elevation = 4,
      this.margin = const EdgeInsets.all(10),
      this.padding = const EdgeInsets.all(10),
      this.alignment = Alignment.topLeft,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          elevation: elevation,
          margin: margin,
          shape: CircleBorder(),
          child: Padding(
            padding: padding,
            child: child,
          ),
        ),
      ),
    );
  }
}
