import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

/* My Imports */
// Constants
import '../constants/theme.dart';
import '../constants/input_fields.dart';

// Utils
import '../utils/color.dart';

// Data Models
import '../models/gradient_color.dart';
import '../models/processing_manager.dart';
import '../models/connection_result_data.dart';

// Services
import '../services/bytecare_api.dart';

// Widgets
import '../widgets/gradient_background.dart';
import '../widgets/gradient_button.dart';
import '../widgets/processing_modal.dart';

// Screens
import 'login_screen.dart';

class RegistrationScreen extends StatefulWidget {
  static String id = 'registration_screen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final Duration _registrationCompletionDelay = Duration(seconds: 3);

  bool _isPasswordVisible = false;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  ProcessingManager _registrationState;

  GestureRecognizer tapRecognizer(void Function() func) =>
      TapGestureRecognizer()..onTap = func;

  void showTermsOfServiceModal() {}

  void showPrivacyPolicyModal() {}

  @override
  void initState() {
    super.initState();
    _registrationState = ProcessingManager(
      modalContainer: _buildContent(),
      modalBuilder: (data, content, message) => Stack(
        children: [
          content,
          Positioned.fill(
            child: Material(
              color: Colors.black45,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ProcessingModal(
                  color: data.color,
                  icon: data.icon,
                  message: message,
                  showWave: data.waveColor != null,
                  waveColor: data.waveColor,
                ),
              ),
            ),
          ),
        ],
      ),
      successData: ConnectionResultData(
        color: kThemeSuccessColor,
        icon: CircleAvatar(
          backgroundColor: darken(kThemeSuccessColor, 65),
          child: Icon(
            Icons.done,
            color: Colors.white,
          ),
        ),
      ),
      errorData: ConnectionResultData(
        color: kThemeErrorColor,
        icon: CircleAvatar(
          backgroundColor: darken(kThemeSuccessColor, 65),
          child: Icon(
            Icons.clear,
            color: Colors.white,
          ),
        ),
      ),
      loadingData: ConnectionResultData(
        color: kThemePrimaryBlue,
        icon: SpinKitPulse(
          color: Colors.white,
        ),
        waveColor: Color.lerp(kThemePrimaryBlue, kThemePrimaryPurple, .5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      themeData: kByteCareThemeData,
      backgroundFill: GradientColor(kThemePrimaryLightLinearGradient),
      ignoreSafeArea: true,
      child: _registrationState.build(_buildContent()),
    );
  }

  Widget _buildContent() {
    return Scaffold(
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
        title: Text(
          'Go Back',
          style: kBody1TextStyle,
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
              'Registration',
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
                    textInputFieldBuilder(
                      decoration: kFormFieldInputDecoration.copyWith(
                        labelText: 'Username (required)',
                        helperText: 'This can be anything unique, including '
                            'your name.',
                      ),
                      validator: MultiValidator([
                        RequiredValidator(
                            errorText: 'This field is '
                                'required.'),
                        MinLengthValidator(
                          1,
                          errorText: 'Your username '
                              'must be between at least 1 characters '
                              'long',
                        ),
                      ]),
                    ),
                    SizedBox(height: kFormFieldSpacing),
                    phoneInputFieldBuilder(
                      decoration: kFormFieldInputDecoration.copyWith(
                        labelText: 'Phone Number (required)',
                      ),
                      validator: MultiValidator([
                        RequiredValidator(errorText: 'This field is required.'),
                        LengthRangeValidator(
                          min: 10,
                          max: 10,
                          errorText: 'Your phone number must be 10 '
                              'digits long.',
                        ),
                        PatternValidator(
                          r'^(0[678]\d)((\d{7})|(( |-)(\d{3})( |-)(\d{4})))',
                          errorText: 'This looks wrong. Please '
                              'recheck it.',
                        ),
                      ]),
                    ),
                    SizedBox(height: kFormFieldSpacing),
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
            Text.rich(
              TextSpan(
                text: 'By signing up you agree to our\n',
                style: kBody2TextStyle,
                children: <InlineSpan>[
                  TextSpan(
                    text: 'Terms of Service',
                    recognizer: tapRecognizer(showTermsOfServiceModal),
                    style: TextStyle().copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(text: ' and '),
                  TextSpan(
                    text: 'Privacy Policy',
                    recognizer: tapRecognizer(showPrivacyPolicyModal),
                    style: TextStyle().copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.0),
            GradientButton(
              onPressed: () async {
                var valid = _formKey.currentState.validate();
                if (!valid) {
                  return;
                }

                setState(() {
                  _registrationState.begin();
                });

                var apiCode = await ByteCareAPI.signup();

                setState(() {
                  _registrationState.complete(apiCode.code, apiCode.message);
                });

                await Future.delayed(_registrationCompletionDelay);

                setState(() {
                  _registrationState.reset();
                });
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
                'Create your Account',
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
          Navigator.popAndPushNamed(context, LoginScreen.id);
        },
        padding: const EdgeInsets.all(16.0),
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Already a member?\n',
              ),
              TextSpan(
                text: 'Log In Here',
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
    );
  }
}
