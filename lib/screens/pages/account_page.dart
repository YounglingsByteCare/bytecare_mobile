import 'package:bytecare_mobile/screens/create_patient_screen.dart';
import 'package:bytecare_mobile/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

/* Project-level Imports */
// Theme
import '../../theme/text.dart';
import '../../theme/form.dart';


// Interfaces
import '../../interfaces/application_page.dart';


// Controllers
import '../../controllers/account.dart';

class AccountPage extends StatefulWidget implements ApplicationPage {
  final IconData _fabIcon;
  final VoidCallback _fabPressed;

  AccountPage({IconData fabIcon, VoidCallback fabPressed})
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
  T _getProvider<T>(BuildContext context, [bool listen = false]) =>
      Provider.of<T>(context, listen: listen);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24.0),
      scrollDirection: Axis.vertical,
      children: [
        Text(
          'Email Address',
          style: kSubtitle2TextStyle,
        ),
        SizedBox(height: 8.0),
        InputDecorator(
          decoration: kFormFieldInputDecoration,
          child: Text(_getProvider<AccountController>(context).email),
        ),
        SizedBox(height: kFormFieldSpacing),
        Row(
          children: [
            Expanded(
              child: Text(
                'Patients',
                style: kSubtitle2TextStyle,
              ),
            ),
            IconButton(
              onPressed: () async {
                await Navigator.pushNamed(context, CreatePatientScreen.id);
                setState(() {});
              },
              icon: Icon(LineAwesomeIcons.plus),
            ),
          ],
        ),
        SizedBox(height: 8.0),
        InputDecorator(
          decoration: kFormFieldInputDecoration.copyWith(
            contentPadding: EdgeInsets.all(0.0),
          ),
          child: _getProvider<AccountController>(context).hasPatients
              ? Column(
                  children: _getProvider<AccountController>(context)
                      .patients
                      .map((e) {
                    return ListTile(
                      title: Text(e.fullName),
                      subtitle: Text(e.idNumber),
                      trailing: IconButton(
                        onPressed: () {
                          setState(() {});
                        },
                        icon: Icon(
                          LineAwesomeIcons.trash,
                          color: kThemeColorError,
                        ),
                      ),
                    );
                  }).toList(),
                )
              : Center(
                  child: Text(
                    'No Patients Available',
                    style: kBody1TextStyle,
                  ),
                ),
        ),
      ],
    );
  }
}
