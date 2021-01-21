import 'package:bytecare_mobile/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

/* Poject-level Imports */
// Constants
import '../constants/theme.dart';

// Services
import '../services/bytecare_api.dart';
import '../services/storage_manager.dart';

// Screens
import 'application_screen.dart';
import 'landing_screen.dart';
import 'login_screen.dart';
import 'errors/no_network.dart';

class SplashScreen extends StatelessWidget {
  static const id = 'splash_screen';

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen.withScreenFunction(
      splashIconSize: 250,
      splash: _buildSplashContent(),
      screenFunction: _splashInit,
    );
  }

  Future<Widget> _splashInit() async {
    var manager = StorageManager();
    var api = ByteCareAPI();

    if (!await ByteCareAPI().testConnection()) {
      return NoNetworkScreen();
    }

    if (await manager.hasLoginToken) {
      manager.setPrefsValue<bool>('has_already_run', true);
      api.authToken = await manager.retrieveLoginToken();
      return ApplicationScreen();
    } else {
      if (await manager.hasPrefsKey('has_already_run')) {
        var value = await manager.getPrefsValue<bool>('has_already_run');
        if (value) {
          return LoginScreen();
        } else {
          manager.setPrefsValue<bool>('has_already_run', true);
          return LandingScreen();
        }
      } else {
        manager.setPrefsValue<bool>('has_already_run', true);
        return LandingScreen();
      }
    }
  }

  Widget _buildSplashContent() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Byte',
                style: kTitle1TextStyle.copyWith(color: kThemePrimaryBlue),
              ),
              TextSpan(
                text: 'Care',
                style: kTitle1TextStyle.copyWith(color: kThemePrimaryPurple),
              ),
            ],
          ),
        ),
        SizedBox(height: 24.0),
        SpinKitWave(
          color: kThemePrimaryBlue,
        ),
      ],
    );
  }
}
