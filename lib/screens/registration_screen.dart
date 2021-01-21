import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

/* My Imports */
// Constants
import '../constants/theme.dart';

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
import 'application_screen.dart';
import 'login_screen.dart';

class RegistrationScreen extends StatefulWidget {
  static String id = 'registration_screen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  bool _isPasswordVisible = false;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  ProcessingManager _registrationState;

  GestureRecognizer tapRecognizer(void Function() func) =>
      TapGestureRecognizer()..onTap = func;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  void showTermsOfServiceModal() {}

  void showPrivacyPolicyModal() {}

  @override
  void initState() {
    super.initState();
    _registrationState = ProcessingManager(
      modalBuilder: (data, content, message) => Stack(
        children: [
          Center(child: content),
          Positioned.fill(
            child: Material(
              color: Colors.black45,
              child: Align(
                alignment: Alignment.center,
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
            LineAwesomeIcons.check,
            color: Colors.white,
          ),
        ),
      ),
      errorData: ConnectionResultData(
        color: kThemeErrorColor,
        icon: CircleAvatar(
          backgroundColor: darken(kThemeSuccessColor, 65),
          child: Icon(
            LineAwesomeIcons.times,
            color: Colors.white,
          ),
        ),
      ),
      loadingData: ConnectionResultData(
        color: kThemePrimaryBlue,
        message: '''We're creating your account right now.
          Don't worry, it'll be quick.''',
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
      backgroundFill: GradientColor(kThemePrimaryAngledLinearGradient),
      ignoreSafeArea: false,
      child: _registrationState.build(_buildContent()),
    );
  }

  Widget _buildContent() {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(80.0),
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Proceed with your',
                  style: kSubtitle1TextStyle.copyWith(
                    color: Colors.white.withOpacity(.9),
                  ),
                ),
                Text(
                  'Registration',
                  style: kTitle1TextStyle.copyWith(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 1.0),
              blurRadius: 16.0,
            ),
          ],
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: <Widget>[
              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 24.0,
                  ),
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
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
                      TextFormField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible,
                        keyboardType: TextInputType.visiblePassword,
                        enableSuggestions: false,
                        decoration: kFormFieldInputDecoration.copyWith(
                          labelText: 'Password (required)',
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                            icon: Icon(
                              _isPasswordVisible
                                  ? LineAwesomeIcons.eye_slash
                                  : LineAwesomeIcons.eye,
                            ),
                          ),
                        ),
                        validator: MultiValidator([
                          RequiredValidator(
                              errorText: 'This field is '
                                  'required'),
                          MinLengthValidator(6,
                              errorText: 'Your password '
                                  'should be at least 6 characters long.'),
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
                onPressed: _registerUser,
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
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: .5),
          FlatButton(
            onPressed: () {
              Navigator.popAndPushNamed(context, LoginScreen.id);
            },
            padding: const EdgeInsets.all(16.0),
            color: Colors.white,
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
        ],
      ),
    );
  }

  void _registerUser() async {
    // Check if form data is valid.
    var valid = _formKey.currentState.validate();
    if (!valid) {
      return;
    }

    // Show processing modal.
    setState(() {
      _registrationState.begin();
    });

    // Send 'signup' api call.
    var registerResult = await ByteCareAPI().signup(
      emailAddress: _emailController.text,
      password: _passwordController.text,
    );

    if (registerResult.code == 200) {
      setState(() {
        _registrationState.complete(
          registerResult.code,
          'Your account is made. Let\'s carry on!',
        );
      });
    } else {
      setState(() {
        _registrationState.completeWithError(
          registerResult.code,
          registerResult.message,
        );
      });

      await Future.delayed(kProcessErrorDelayDuration);

      setState(() {
        _registrationState.reset();
      });
      return;
    }

    var loginResult = await ByteCareAPI().login(
      emailAddress: _emailController.text,
      password: _passwordController.text,
    );

    if (loginResult.code == 200) {
      await Future.delayed(kProcessDelayDuration);

      Navigator.pushNamedAndRemoveUntil(
          context, ApplicationScreen.id, (r) => false);
    } else {
      setState(() {
        _registrationState.completeWithError(400, '');
      });

      await Future.delayed(kProcessDelayDuration);

      setState(() {
        _registrationState.reset();
      });
      return;
    }
  }
}
