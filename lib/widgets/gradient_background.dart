import 'package:flutter/material.dart';

/* Project-level Imports */
// Data Models
import '../models/gradient_color.dart';

class GradientBackground extends StatelessWidget {
  final ThemeData themeData;
  final GradientColor backgroundFill;
  final Widget child;
  final bool ignoreSafeArea;

  GradientBackground({
    @required this.backgroundFill,
    this.themeData,
    this.child,
    this.ignoreSafeArea,
  });

  @override
  Widget build(BuildContext context) {
    Widget current = child;

    if (!ignoreSafeArea) {
      current = SafeArea(child: child);
    }

    current = Container(
      decoration: BoxDecoration(
        gradient: backgroundFill.fillAsGrad,
        color: backgroundFill.fillAsColor,
      ),
      child: current,
    );

    if (themeData != null) {
      current = Theme(
        data: themeData,
        child: current,
      );
    }

    return current;
  }
}
