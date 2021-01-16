import 'package:flutter/material.dart';

/* My Imports */
// Constants
import '../constants/theme.dart';

// Data Models
import '../models/gradient_color.dart';

// Widgets
import '../widgets/information_carousel.dart';
import '../widgets/gradient_background.dart';
import '../widgets/gradient_button.dart';

// Screens
import 'login_screen.dart';
import 'registration_screen.dart';

class LandingScreen extends StatelessWidget {
  static final String id = 'welcome_screen';

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      themeData: kByteCareThemeData,
      backgroundFill: GradientColor(kThemePrimaryLightLinearGradient),
      ignoreSafeArea: true,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          toolbarHeight: kToolbarHeight * 2,
          title: Text(
            'ByteCare',
            textAlign: TextAlign.center,
            style: kTitle1TextStyle,
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InformationCarousel(
                titleStyle: kTitle2TextStyle,
                subtitleStyle: kSubtitle2TextStyle,
                primaryColor: kThemePrimaryBlue,
                backgroundColor: Colors.white,
                carouselShadow: BoxShadow(
                  color: Colors.black.withAlpha(0x7),
                  offset: Offset(0, 1.0),
                  blurRadius: 3.0,
                ),
              ),
              Divider(
                height: 40.0,
                indent: 64.0,
                endIndent: 64.0,
              ),
              Row(
                children: <Widget>[
                  Flexible(
                    child: GradientButton(
                      onPressed: () {
                        Navigator.pushNamed(context, RegistrationScreen.id);
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
                      backgroundFill: GradientColor(
                        Colors.white,
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
    );
  }
}
