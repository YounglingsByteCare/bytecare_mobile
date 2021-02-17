import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/* Project-level Imports */
// Theme
import '../theme/colors.dart';
import '../theme/text.dart';

// Controllers
import '../controllers/account.dart';
import '../controllers/hospital_marker.dart';

// Services
import '../services/auth_storage.dart';
import '../services/byte_care_api.dart';

// Screens
import 'application_screen.dart';
import 'landing_screen.dart';
import 'login_screen.dart';
import 'errors/connection_failed.dart';
import 'errors/no_server.dart';
import 'errors/unknown_error.dart';

class SplashScreen extends StatefulWidget {
  static const id = 'splash_screen';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  BuildContext _context;

  String _loadingText = '';

  @override
  Widget build(BuildContext context) {
    this._context = context;

    return AnimatedSplashScreen.withScreenFunction(
      splashIconSize: 250.0,
      splash: _buildSplashContent(),
      screenFunction: _splashInit,
    );
  }

  Widget _buildSplashContent() {
    return Column(
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Byte',
                style: kTitle1TextStyle.copyWith(color: kThemeColorPrimary),
              ),
              TextSpan(
                text: 'Care',
                style: kTitle1TextStyle.copyWith(color: kThemeColorSecondary),
              ),
            ],
          ),
        ),
        SizedBox(height: 32.0),
        SpinKitWave(color: kThemeColorPrimary),
        SizedBox(height: 24.0),
        Text(this._loadingText, style: kBody1TextStyle),
      ],
    );
  }

  T _getProvider<T>(BuildContext context, [bool listen = false]) =>
      Provider.of<T>(context, listen: listen);

  Future<Widget> _splashInit() async {
    try {
      var store = AuthStorage.getInstance();
      var prefs = await SharedPreferences.getInstance();
      Widget result;

      var api = ByteCareApi.getInstance();
      if (!await api.testConnection()) return NoServer(widget);

      try {
        setState(() {
          _loadingText = 'Loading Hospital Data';
        });
        await _getProvider<HospitalMarkerController>(this._context)
            .loadHospitals();
      } on ServerNotAvailableException {
        result = NoServer(widget);
      }

      if (await store.hasLoginToken) {
        prefs.setBool('is_first_run', true);
        var token = await store.retrieveLoginToken();

        _getProvider<AccountController>(this._context).token = token;

        try {
          setState(() {
            _loadingText = 'Loading User Data';
          });
          var res =
              await _getProvider<AccountController>(this._context).loadUser(
            _getProvider<HospitalMarkerController>(this._context).hospitals,
          );

          if (res.code != 200) {
            result = ConnectionFailed(widget);
          }
        } on ServerNotAvailableException {}

        result = ApplicationScreen();
      } else {
        if (prefs.containsKey('is_first_run')) {
          var value = !prefs.getBool('is_first_run');
          if (value) {
            result = LoginScreen();
          } else {
            prefs.setBool('is_first_run', true);
            result = LandingScreen();
          }
        } else {
          prefs.setBool('is_first_run', true);
          result = LandingScreen();
        }
      }

      return result;
    } catch (e) {
      return UnknownError(e);
    }
  }
}
