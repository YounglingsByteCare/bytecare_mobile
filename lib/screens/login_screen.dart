import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

/* My Imports */
// Constants
import '../constants/theme.dart';
import '../constants/input_fields.dart';

// Data Models
import '../models/gradient_color.dart';

// Widgets
import '../widgets/gradient_background.dart';
import '../widgets/gradient_button.dart';

// Screens
import 'registration_screen.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordVisible = false;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      themeData: kByteCareThemeData,
      backgroundFill: GradientColor(kThemePrimaryLightLinearGradient),
      ignoreSafeArea: true,
      child: Scaffold(
        backgroundColor: Colors.transparent,
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
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: <Widget>[
              Text(
                'Proceed with your',
                style: kSubtitle1TextStyle,
              ),
              Text(
                'Login',
                style: kTitle1TextStyle,
              ),
              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 24.0,
                  ),
                  child: Column(
                    children: <Widget>[
                      emailInputFieldBuilder(
                        decoration: kFormFieldInputDecoration.copyWith(
                          labelText: 'Email Address (required)',
                        ),
                        validator: MultiValidator([
                          RequiredValidator(
                              errorText: 'This field is '
                                  'required.'),
                          EmailValidator(
                            errorText: 'This is not a valid email address.',
                          ),
                        ]),
                      ),
                      SizedBox(height: kFormFieldSpacing),
                      passwordInputFieldBuilder(
                        decoration: kFormFieldInputDecoration.copyWith(
                          labelText: 'Password (required)',
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                        ),
                        obscureText: _isPasswordVisible,
                        validator: MultiValidator([
                          RequiredValidator(
                              errorText: 'This field is '
                                  'required'),
                          MinLengthValidator(8,
                              errorText: 'Your password '
                                  'should be at least 8 characters long.'),
                        ]),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 8.0),
              // SizedBox(height: 16.0),
              GradientButton(
                onPressed: () {
                  _formKey.currentState.validate();
                },
                backgroundFill: GradientColor(
                  kButtonBackgroundLinearGradient,
                ),
                borderRadius: BorderRadius.circular(8.0),
                padding: EdgeInsets.symmetric(
                  vertical: 16.0,
                  horizontal: 24.0,
                ),
                child: Text(
                  'Log In',
                  style: kButtonBody1TextStyle.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: FlatButton(
          onPressed: () {
            Navigator.popAndPushNamed(context, RegistrationScreen.id);
          },
          padding: const EdgeInsets.all(16.0),
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Don\'t have an account?\n',
                ),
                TextSpan(
                  text: 'Create one here',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
              style: kBody1TextStyle,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
