import 'package:flutter/material.dart';
import 'package:ms_undraw/ms_undraw.dart' show UnDrawIllustration;

/* Project-level Imports */
// Theme
import '../theme/themes.dart';
import '../theme/text.dart';
import '../theme/colors.dart';
import '../theme/gradients.dart';

// Data Models
import '../models/gradient_color.dart';

// Widgets
import '../widgets/information_carousel.dart';
import '../widgets/gradient_button.dart';

// Screens
import 'login_screen.dart';
import 'registration_screen.dart';

class LandingScreen extends StatelessWidget {
  static final String id = 'landing_screen';

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: kByteCareThemeData,
      child: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Container(
        height: double.infinity,
        color: Colors.white,
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 48.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Byte',
                        style: TextStyle(
                          color: kThemeColorPrimary,
                        ),
                      ),
                      TextSpan(
                        text: 'Care',
                        style: TextStyle(
                          color: kThemeColorSecondary,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                  style: kTitle1TextStyle.copyWith(
                    fontWeight: FontWeight.w100,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    'Your medical clinic booking system.',
                    textAlign: TextAlign.start,
                    style: kSubtitle2TextStyle,
                  ),
                ),
                SizedBox(height: 32.0),
                InformationCarousel(
                  titleStyle: kTitle2TextStyle,
                  subtitleStyle: kBody2TextStyle,
                  primaryColor: kThemeColorPrimary,
                  backgroundColor: Colors.grey.shade100,
                  items: <InformationCarouselItem>[
                    InformationCarouselItem(
                      illustration: UnDrawIllustration.security,
                      title: 'Security',
                      description:
                          'We work hard to ensure that our application '
                          'incorporates top security measures to protect your '
                          'data.',
                    ),
                    InformationCarouselItem(
                      illustration: UnDrawIllustration.in_no_time,
                      title: 'Safety',
                      description:
                          'We keep you healthier by reducing the amount of '
                          'time spent waiting in overcrowded, infectiour '
                          'waiting rooms.',
                    ),
                    InformationCarouselItem(
                      illustration: UnDrawIllustration.in_no_time,
                      title: 'Efficiency',
                      description: 'Our product saves you time and energy by '
                          'streamlining the hospital check-in system.',
                    ),
                  ],
                ),
                SizedBox(height: 40.0),
                Row(
                  children: <Widget>[
                    Flexible(
                      child: GradientButton(
                        onPressed: () {
                          Navigator.pushNamed(context, RegistrationScreen.id);
                        },
                        background: GradientColorModel(
                          kButtonBackgroundLinearGradient,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                        padding: EdgeInsets.symmetric(
                          vertical: 16.0,
                          horizontal: 24.0,
                        ),
                        child: Text(
                          'Sign Up',
                          style: kButtonBody1TextStyle.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16.0),
                    Flexible(
                      child: GradientButton(
                        onPressed: () {
                          Navigator.pushNamed(context, LoginScreen.id);
                        },
                        background: GradientColorModel(
                          Colors.grey.shade100,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                        padding: EdgeInsets.symmetric(
                          vertical: 16.0,
                          horizontal: 24.0,
                        ),
                        child: Text(
                          'Login',
                          style: kButtonBody1TextStyle.copyWith(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
