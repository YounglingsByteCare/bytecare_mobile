import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';

/* Project-level Imports */
// Constants
import '../theme/themes.dart';
import '../theme/text.dart';
import '../theme/colors.dart';
import '../theme/gradients.dart';
import '../theme/form.dart';

// Utils
import '../utils/color.dart';

// Data Models
import '../models/gradient_color.dart';
import '../models/processing_dialog_theme.dart';

// Controllers
import '../controllers/account.dart';
import '../controllers/hospital_marker.dart';
import '../controllers/processing_view.dart';

// Services
import '../services/auth_storage.dart';
import '../services/byte_care_api.dart';

// Widgets
import '../widgets/gradient_background.dart';
import '../widgets/gradient_button.dart';
import '../widgets/processing_dialog.dart';

// Screens
import 'application_screen.dart';
import 'create_patient_screen.dart';
import 'forgot_password_screen.dart';
import 'registration_screen.dart';
import 'errors/no_server.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordVisible = false;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  ProcessingViewController _processState;

  TextEditingController _emailController =
      TextEditingController(text: 'orange@gmail.com');
  TextEditingController _passwordController =
      TextEditingController(text: 'tomato');

  @override
  void initState() {
    super.initState();
    _processState = ProcessingViewController(
      modalBuilder: (data, content, message) {
        return Stack(
          fit: StackFit.loose,
          alignment: AlignmentDirectional.center,
          children: [
            content,
            Positioned.fill(
              child: Material(
                color: Colors.black45,
                child: Align(
                  alignment: Alignment.center,
                  child: ProcessingDialog(
                    color: data.color,
                    icon: data.icon,
                    message: message,
                    showWave: false,
                    waveColor: data.waveColor,
                  ),
                ),
              ),
            ),
          ],
        );
      },
      successData: ProcessingDialogThemeModel(
        color: kThemeColorSuccess,
        message: 'We\'ve successfully got your data, now let\'s get to '
            'working.',
        icon: CircleAvatar(
          backgroundColor: darken(kThemeColorSuccess, 65),
          child: Icon(
            LineAwesomeIcons.check,
            color: Colors.white,
          ),
        ),
      ),
      errorData: ProcessingDialogThemeModel(
        color: kThemeColorError,
        message: 'There was an error when loading your data. Please try '
            'again.',
        icon: CircleAvatar(
          backgroundColor: darken(kThemeColorError, 65),
          child: Icon(
            LineAwesomeIcons.times,
            color: Colors.white,
          ),
        ),
      ),
      loadingData: ProcessingDialogThemeModel(
        color: kThemeColorPrimary,
        message: 'We\'re signing you in, enjoy your stay.',
        waveColor: kThemeColorSecondary,
        icon: SpinKitPulse(
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _processState.build(
      GradientBackground(
        theme: kByteCareThemeData,
        background: GradientColorModel(kThemeGradientPrimaryAngled),
        ignoreSafeArea: true,
        child: _buildContent(context),
      ),
    );
  }

  Scaffold _buildContent(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        leading: Navigator.canPop(context)
            ? BackButton(
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            : Container(),
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
                background: GradientColorModel(
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

  T _getProvider<T>(BuildContext context, [bool listen = false]) {
    return Provider.of<T>(context, listen: listen);
  }

  void _loginUser() async {
    var valid = _formKey.currentState.validate();
    if (!valid) {
      return;
    }

    setState(() {
      _processState.begin();
    });

    var loginResult;

    try {
      loginResult = await _getProvider<AccountController>(this.context).login(
        _emailController.text,
        _passwordController.text,
      );
    } on ServerNotAvailableException {
      _processState.reset();

      Navigator.push(
        this.context,
        MaterialPageRoute(builder: ((context) => NoServer(widget))),
      );
      return;
    }

    if (loginResult.code == 200) {
      var token = loginResult.data['token'];
      print('Storing Login Token');
      AuthStorage.getInstance().storeLoginToken(token);
      print('Completed Storing');
      setState(() {
        _processState.complete(
          loginResult.code,
          'Login Successful\nThanks for coming back.',
        );
      });

      await _getProvider<AccountController>(this.context).loadUser(
        _getProvider<HospitalMarkerController>(this.context).hospitals,
      );

      if (_getProvider<AccountController>(this.context).hasPatients) {
        Navigator.pushNamedAndRemoveUntil(
          this.context,
          ApplicationScreen.id,
          (r) => false,
        );
      } else {
        Navigator.push(
          this.context,
          MaterialPageRoute(
            builder: (context) {
              return CreatePatientScreen(returnPageId: ApplicationScreen.id);
            },
          ),
        );
      }
    } else {
      setState(() {
        _processState.completeWithError(
          loginResult.code,
          loginResult.message,
        );
      });

      await Future.delayed(kProcessErrorDelayDuration);

      setState(() {
        _processState.reset();
      });

      return;
    }
  }
}
