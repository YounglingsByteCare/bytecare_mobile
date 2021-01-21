import 'package:flutter/material.dart';
import 'package:ms_undraw/ms_undraw.dart';
import 'package:geolocator/geolocator.dart';
import 'package:open_settings/open_settings.dart';

/* Project-level Imports */
// Constants
import '../../constants/theme.dart';

// Data Models
import '../../models/gradient_color.dart';

// Widgets
import '../../widgets/gradient_button.dart';

class DeniedLocationPermissionErrorScreen extends StatelessWidget {
  static const String id = 'error.denied_location_permission';

  void _checkPermission(BuildContext context) async {
    if (await Geolocator.isLocationServiceEnabled()) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    _checkPermission(context);

    return MaterialApp(
      home: Scaffold(
        backgroundColor: kThemePrimaryBlue,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AspectRatio(
                  aspectRatio: 10 / 9,
                  child: UnDraw(
                    illustration: UnDrawIllustration.not_found,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Oh No',
                  style: kTitle1TextStyle.copyWith(
                    color: Colors.white,
                  ),
                ),
                Text(
                  'We don\'t have permission to get your location '
                  'so now we can\'t help you find any clinic\'s near you.',
                  style: kBody1TextStyle.copyWith(
                    color: Colors.white.withOpacity(.8),
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  'Please go to you settings and allow us this permission.',
                  style: kBody1TextStyle.copyWith(
                    color: Colors.white.withOpacity(.8),
                  ),
                ),
                SizedBox(height: 32.0),
                IntrinsicWidth(
                  child: GradientButton(
                    onPressed: () async {
                      await OpenSettings.openAppSetting();
                    },
                    borderRadius: BorderRadius.circular(8.0),
                    padding: EdgeInsets.symmetric(
                      vertical: 16.0,
                      horizontal: 32.0,
                    ),
                    backgroundFill: GradientColor(Colors.white),
                    child: Text(
                      'Go to Settings.',
                      style: kButtonBody1TextStyle.copyWith(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
