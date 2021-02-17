import 'package:bytecare_mobile/screens/create_patient_screen.dart';
import 'package:bytecare_mobile/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

/* Project-level Imports */
// Theme
import '../../theme/text.dart';
import '../../theme/form.dart';

// Utils
import '../../utils/color.dart';

// Interfaces
import '../../interfaces/application_page.dart';

// Controllers
import '../../controllers/account.dart';

// Screens
import '../../screens/verify_email_screen.dart';

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
        SizedBox(height: 8.0),
        ListTile(
          tileColor: kThemeColorWarning.withAlpha(0x16),
          shape: RoundedRectangleBorder(
            side: BorderSide(color: kThemeColorWarning),
            borderRadius: BorderRadius.circular(8.0),
          ),
          title: Text(
            'Your email isn\'t verified',
            style: kBody1TextStyle.copyWith(
              color: darken(kThemeColorWarning, 35),
            ),
          ),
          trailing: IntrinsicWidth(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, VerifyEmailScreen.id);
              },
              style: ElevatedButton.styleFrom(
                primary: kThemeColorWarning,
                shadowColor: kThemeColorWarning,
              ),
              child: Text(
                'Verify Now',
                style: kButtonBody2TextStyle.copyWith(color: Colors.black),
              ),
            ),
          ),
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
                          WidgetsBinding.instance
                              .addPostFrameCallback((timeStamp) async {
                            bool confirmation = await showDialog<bool>(
                              context: this.context,
                              barrierColor: Colors.black12,
                              barrierDismissible: false,
                              builder: (context) =>
                                  _buildPatientDeleteConfirmationDialog(),
                            );

                            if (confirmation) {
                              _getProvider<AccountController>(this.context)
                                  .deletePatient(e.idNumber);

                              setState(() {});
                            }
                          });
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

  Widget _buildPatientDeleteConfirmationDialog() {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'Confirm Patient Delete',
              style: kTitle2TextStyle,
            ),
            SizedBox(height: 8.0),
            Text(
              'Are you sure you want to delete the selected patient?',
              style: kBody1TextStyle,
            ),
            SizedBox(height: 16.0),
            ButtonBar(
              layoutBehavior: ButtonBarLayoutBehavior.constrained,
              children: [
                FlatButton(
                  onPressed: () {},
                  child: Text('No'),
                ),
                FlatButton(
                  onPressed: () {},
                  child: Text('Yes'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
