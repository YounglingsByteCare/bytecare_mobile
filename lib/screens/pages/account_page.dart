import 'package:flutter/material.dart';

/* Project-level Imports */
// Interfaces
import '../../interfaces/application_page.dart';

class AccountPage extends StatefulWidget implements ApplicationPage {
  final IconData _fabIcon;
  final void Function() _fabPressed;

  AccountPage({IconData fabIcon, void Function() fabPressed})
      : _fabIcon = fabIcon,
        _fabPressed = fabPressed;

  @override
  _AccountPageState createState() => _AccountPageState();

  @override
  Widget asWidget() => this;

  @override
  IconData getFabIcon() => _fabIcon;

  @override
  void Function() getFabPressed() => _fabPressed;

  @override
  get usesFab => _fabIcon != null && _fabPressed != null;
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
