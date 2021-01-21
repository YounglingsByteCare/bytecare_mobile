import 'package:flutter/material.dart';

/* Project-level Imports */
// Interfaces
import '../../interfaces/application_page.dart';

class BlankApplicationPage extends StatelessWidget implements ApplicationPage {
  @override
  Widget build(BuildContext context) {
    return Container();
  }

  @override
  Widget asWidget() => this;

  @override
  IconData getFabIcon() => null;

  @override
  void Function() getFabPressed() => null;

  @override
  // TODO: implement usesFab
  get usesFab => false;
}
