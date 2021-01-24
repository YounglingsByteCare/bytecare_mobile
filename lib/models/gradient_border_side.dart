import 'package:flutter/material.dart';

import 'gradient_color.dart';

class GradientBorderSide {
  final GradientColorModel borderFill;
  final double width;

  static GradientBorderSide zero = GradientBorderSide(
    borderFill: GradientColorModel(Colors.transparent),
    width: 0,
  );

  GradientBorderSide({@required this.borderFill, this.width = 1.0})
      : assert(width > 0);

  bool get isGradientBorder => borderFill.isGradient;

  bool get isVisible => borderFill.fillValue != Colors.transparent && width > 0;
}
