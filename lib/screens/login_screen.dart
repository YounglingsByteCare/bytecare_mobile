import 'package:flutter/material.dart';

/* My Imports */
// Constants
import '../constants/theme.dart';

// Screens
import 'registration_screen.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: kByteCareThemeData,
      child: Container(
        decoration: BoxDecoration(
          gradient: kThemePrimaryLightLinearGradient,
        ),
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(
                  Icons.chevron_left,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: Text(
                'Go Back',
                style: kBodyTextStyle,
              ),
              actions: [
                FlatButton(
                  onPressed: () {
                    Navigator.popAndPushNamed(context, RegistrationScreen.id);
                  },
                  child: Text('Create an Account Now'),
                ),
              ],
            ),
            body: SingleChildScrollView(),
          ),
        ),
      ),
    );
  }
}
