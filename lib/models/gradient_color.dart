import 'package:flutter/material.dart';

class GradientColor {
  final dynamic fillValue;
  final bool _isGradient;

  const GradientColor(this.fillValue)
      : assert(fillValue is Gradient || fillValue is Color),
        _isGradient = fillValue is Gradient;

  bool get isGradient => _isGradient;

  Color get fillAsColor => _isGradient ? null : fillValue;

  Gradient get fillAsGrad => _isGradient ? fillValue : null;
}
