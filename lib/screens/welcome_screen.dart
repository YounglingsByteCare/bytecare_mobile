import 'package:flutter/material.dart';
import 'package:ms_undraw/ms_undraw.dart' show UnDraw, UnDrawIllustration;

/* My Imports */
// Constants
import '../constants/theme.dart';

// Widgets
import '../widgets/gradient_button.dart';

// Screens
import 'login_screen.dart';
import 'registration_screen.dart';

class WelcomeScreen extends StatelessWidget {
  static final String id = 'welcome_screen';

  @override
  Widget build(BuildContext context) {

    return Theme(
      data: kByteCareThemeData,
      child: Container(
        decoration: BoxDecoration(
          gradient: kThemePrimaryLightLinearGradient,
        ),
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            resizeToAvoidBottomInset: false,
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'ByteCare',
                      textAlign: TextAlign.center,
                      style: kTitle1TextStyle,
                    ),
                    SizedBox(height: 16.0),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(24.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(
                          color: Colors.white,
                          width: 3.0,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          AspectRatio(
                            aspectRatio: 10 / 9,
                            child: UnDraw(
                              color: kThemePrimaryPurple,
                              illustration: UnDrawIllustration.security,
                            ),
                          ),
                          Text(
                            'Safety',
                            style: kTitle2TextStyle,
                          ),
                          Text('We work hard'),
                        ],
                      ),
                    ),
                    SizedBox(height: 32.0),
                    GradientButton(
                      backgroundFill: GradientColor(
                        kButtonBackgroundLinearGradient,
                      ),
                      borderRadius: BorderRadius.circular(4.0),
                      borderSide: GradientBorderSide.zero,
                      padding: EdgeInsets.symmetric(
                        vertical: 20.0,
                        horizontal: 36.0,
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, RegistrationScreen.id);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Get Started Now',
                                style: kButtonBody1TextStyle.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'Create an Account',
                                style: kButtonBody2TextStyle.copyWith(
                                  color: Colors.white.withOpacity(0.65),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 24.0),
                          Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24.0),
                    Text('Already have an account?'),
                    SizedBox(height: 8.0),
                    GradientButton(
                      onPressed: () {
                        print('I\'m going to ${LoginScreen.id} now.');
                        Navigator.pushNamed(context, LoginScreen.id);
                      },
                      backgroundFill: GradientColor(Colors.white),
                      elevation: 1.0,
                      borderSide: GradientBorderSide(
                        borderFill:
                            GradientColor(kButtonBackgroundLinearGradient),
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(4.0),
                      padding: EdgeInsets.symmetric(
                        vertical: 20.0, // vertical pad (16) + stroke extra (4)
                        horizontal: 32.0,
                      ),
                      child: Text(
                        'Sign In',
                        style: kButtonBody1TextStyle,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
