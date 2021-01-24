import 'package:flutter/material.dart';

import './colors.dart';
import './text.dart';

final ThemeData kByteCareThemeData = ThemeData.light().copyWith(
  appBarTheme: kClearAppBarTheme,
  primaryColor: kThemeColorPrimary,
);

// This is the AppBarTheme for the 'clear' AppBar.
final AppBarTheme kClearAppBarTheme = AppBarTheme(
  elevation: 0.0,
  color: Colors.transparent,
  textTheme: TextTheme(
    headline6: kTitle1TextStyle,
  ),
);

final Duration kProcessDelayDuration = Duration(milliseconds: 350);
final Duration kProcessErrorDelayDuration = Duration(seconds: 5);
