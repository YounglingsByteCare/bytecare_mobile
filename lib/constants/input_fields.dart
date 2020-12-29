import 'package:flutter/material.dart';

/*
 * Project-level imports
 */
// Constants
import 'theme.dart';

// Utilities
import '../utils/color.dart';

const double kTextInputFieldElevation = 1.0;

Widget textInputFieldBuilder(InputDecoration inputDecoration) {
  return Material(
    elevation: kTextInputFieldElevation,
    shadowColor: brighten(kThemePrimaryBlue, 90),
    borderRadius: BorderRadius.circular(4.0),
    child: TextFormField(
      decoration: inputDecoration,
    ),
  );
}

Widget emailInputFieldBuilder(InputDecoration inputDecoration) {
  return Material(
    elevation: kTextInputFieldElevation,
    shadowColor: brighten(kThemePrimaryBlue, 90),
    borderRadius: BorderRadius.circular(4.0),
    child: TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: inputDecoration,
    ),
  );
}

Widget passwordInputFieldBuilder(
  InputDecoration inputDecoration,
  bool obscureText,
) {
  return Material(
    elevation: kTextInputFieldElevation,
    shadowColor: Colors.black,
    borderRadius: BorderRadius.circular(4.0),
    child: TextFormField(
      obscureText: obscureText,
      keyboardType: TextInputType.visiblePassword,
      decoration: inputDecoration,
    ),
  );
}
