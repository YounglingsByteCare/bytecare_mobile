import 'package:flutter/material.dart';

abstract class ApplicationPage {
  get usesFab;

  IconData getFabIcon();

  void Function() getFabPressed();

  Widget asWidget();
}
