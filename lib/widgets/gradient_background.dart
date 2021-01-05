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
    return Theme(
      data: themeData,
      child: Container(
        decoration: BoxDecoration(
          gradient: backgroundFill.fillAsGrad, // NOTE: Can I pass null here?
          color: backgroundFill.fillAsColor,
        ),
        child: ignoreSafeArea
            ? SafeArea(
                child: child,
              )
            : child,
      ),
    );
  }
}
