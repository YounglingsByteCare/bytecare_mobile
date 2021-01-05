import 'package:flutter/material.dart';

/* Project-level Imports */
import 'gradient_color.dart';

class GradientBorderSide {
  final GradientColor borderFill;
  final double width;

  static GradientBorderSide zero = GradientBorderSide(
    borderFill: GradientColor(Colors.transparent),
    width: 0,
  );

  GradientBorderSide({
    @required this.borderFill,
    this.width = 1.0,
  });

  bool get isGradientBorder => borderFill.isGradient;
}
