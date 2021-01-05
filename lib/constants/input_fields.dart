import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';


const double kTextInputFieldElevation = 4.0;

// Input Field Builders, to easily build element of certain properties.
Widget textInputFieldBuilder(
    {InputDecoration decoration, FieldValidator validator}) {
  return TextFormField(
    decoration: decoration,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    validator: validator,
  );
}

Widget phoneInputFieldBuilder(
    {InputDecoration decoration, FieldValidator validator}) {
  return TextFormField(
    keyboardType: TextInputType.phone,
    decoration: decoration,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    validator: validator,
  );
}

Widget emailInputFieldBuilder(
    {InputDecoration decoration, FieldValidator validator}) {
  return TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: decoration,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validator);
}

Widget passwordInputFieldBuilder({
  InputDecoration decoration,
  FieldValidator validator,
  bool obscureText,
}) {
  return TextFormField(
    obscureText: obscureText,
    keyboardType: TextInputType.visiblePassword,
    decoration: decoration,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    enableSuggestions: false,
    validator: validator,
  );
}
