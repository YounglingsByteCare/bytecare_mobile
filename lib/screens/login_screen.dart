import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
import 'registration_screen.dart';
import 'application_screen.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordVisible = false;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  ProcessingManager _loginState;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loginState = ProcessingManager(
      modalBuilder: (data, content, message) => Stack(
        children: [
          content,
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
      backgroundFill: GradientColor(kThemePrimaryLightLinearGradient),
      ignoreSafeArea: true,
      child: _loginState.build(_buildContent()),
    );
  }

  Scaffold _buildContent() {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
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
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      controller: _emailController,
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
                      obscureText: !_isPasswordVisible,
                      controller: _passwordController,
                      textInputAction: TextInputAction.done,
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
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                        ),
                      ),
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
              onPressed: () async {
                var valid = _formKey.currentState.validate();
                if (!valid) {
                  return;
                }

                setState(() {
                  _loginState.begin();
                });

                var loginResult = await ByteCareAPI().login(
                  emailAddress: _emailController.text,
                  password: _passwordController.text,
                );

                if (loginResult.code == 200) {
                  setState(() {
                    _loginState.complete(
                      loginResult.code,
                      'Login Successful\nThanks for coming back.',
                    );
                  });

                  await Future.delayed(kProcessDelayDuration);

                  Navigator.pushNamedAndRemoveUntil(
                      context, ApplicationScreen.id, (r) => false);
                } else {
                  setState(() {
                    _loginState.completeWithError(
                      loginResult.code,
                      loginResult.message,
                    );
                  });
                }
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
            SizedBox(height: 8.0),
            FlatButton(
              onPressed: () {},
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text('Forgot your passsword?'),
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
    );
  }
}
