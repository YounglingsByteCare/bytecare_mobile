import 'package:flutter/material.dart';

class GradientColorModel {
  final dynamic fillValue;
  final bool isGradient;

  GradientColorModel(this.fillValue)
      : assert(fillValue is Gradient || fillValue is Color),
        isGradient = fillValue is Gradient;

  Color get fillAsColor => isGradient ? null : fillValue;

  Gradient get fillAsGrad => isGradient ? fillValue : null;
}
