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
import '../services/storage_manager.dart';

// Widgets
import '../widgets/gradient_background.dart';
import '../widgets/gradient_button.dart';
import '../widgets/processing_modal.dart';

// Screens
import 'application_screen.dart';
import 'forgotpassword_screen.dart';
import 'registration_screen.dart';

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
        message: '''We're signing you in, enjoy your stay.''',
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
                  'Login',
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
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
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
              // SizedBox(height: 16.0),
              GradientButton(
                onPressed: _loginUser,
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
                onPressed: () {
                  Navigator.pushNamed(context, ForgotPasswordScreen.id);
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text('Forgot your passsword?'),
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
              Navigator.popAndPushNamed(context, RegistrationScreen.id);
            },
            padding: const EdgeInsets.all(16.0),
            color: Colors.white,
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
        ],
      ),
    );
  }

  void _loginUser() async {
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
      StorageManager().storeLoginToken(ByteCareAPI().authToken);
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

      await Future.delayed(kProcessErrorDelayDuration);

      setState(() {
        _loginState.reset();
      });
      return;
    }
  }
}
