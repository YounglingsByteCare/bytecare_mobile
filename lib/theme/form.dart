import 'package:flutter/material.dart';

import './colors.dart';

final double kFormFieldSpacing = 20.0;
const double kTextInputFieldElevation = 4.0;

final kFormFieldInputDecoration = InputDecoration(
  filled: true,
  fillColor: Colors.white,
  contentPadding: EdgeInsets.symmetric(
    vertical: 16.0,
    horizontal: 20.0,
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.grey.shade300,
      width: 1.0,
    ),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: kThemeColorPrimary,
      width: 1.0,
    ),
  ),
  errorBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: kThemeColorError,
      width: 1.0,
    ),
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: kThemeColorError,
      width: 2.0,
    ),
  ),
);
