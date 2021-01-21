import 'package:flutter/material.dart';
import 'package:ms_undraw/ms_undraw.dart';

/* My Imports */
// Constants
import '../constants/theme.dart';

// Data Models
import '../models/gradient_color.dart';

// Widgets
import '../widgets/information_carousel.dart';
import '../widgets/gradient_button.dart';

// Screens
import 'login_screen.dart';
import 'registration_screen.dart';

class LandingScreen extends StatelessWidget {
  static final String id = 'welcome_screen';

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: kByteCareThemeData,
      child: _buildContent(context),
    );
  }

  // Widget _buildContent(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: Colors.transparent,
  //     resizeToAvoidBottomInset: false,
  //     body: CustomScrollView(
  //       slivers: [
  //         SliverAppBar(
  //           centerTitle: true,
  //           kToo
  //           title: Text(
  //             'ByteCare',
  //             textAlign: TextAlign.center,
  //             style: kTitle2TextStyle.copyWith(
  //               color: Colors.white,
  //               fontWeight: FontWeight.w400,
  //             ),
  //           ),
  //         ),
  //         SliverFillRemaining(
  //           child: Container(
  //             decoration: BoxDecoration(
  //               color: Colors.white,
  //               borderRadius: BorderRadius.vertical(
  //                 top: Radius.circular(48.0),
  //               ),
  //               boxShadow: [
  //                 BoxShadow(
  //                   color: Colors.black26,
  //                   offset: Offset(0, 1),
  //                   blurRadius: 16.0,
  //                 ),
  //               ],
  //             ),
  //             child: SingleChildScrollView(
  //               padding: const EdgeInsets.all(24.0),
  //               child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.start,
  //                 children: [
  //                   InformationCarousel(
  //                     titleStyle: kTitle2TextStyle,
  //                     subtitleStyle: kSubtitle2TextStyle,
  //                     primaryColor: kThemePrimaryBlue,
  //                     // backgroundColor: Colors.white,
  //                     // carouselShadow: BoxShadow(
  //                     //   color: Colors.black.withAlpha(0x7),
  //                     //   offset: Offset(0, 1.0),
  //                     //   blurRadius: 3.0,
  //                     // ),
  //                   ),
  //                   Divider(
  //                     height: 40.0,
  //                     indent: 64.0,
  //                     endIndent: 64.0,
  //                   ),
  //                   Row(
  //                     children: <Widget>[
  //                       Flexible(
  //                         child: GradientButton(
  //                           onPressed: () {
  //                             Navigator.pushNamed(
  //                                 context, RegistrationScreen.id);
  //                           },
  //                           backgroundFill: GradientColor(
  //                             kButtonBackgroundLinearGradient,
  //                           ),
  //                           borderRadius: BorderRadius.circular(8.0),
  //                           padding: EdgeInsets.symmetric(
  //                             vertical: 16.0,
  //                             horizontal: 24.0,
  //                           ),
  //                           child: Text(
  //                             'Sign Up',
  //                             style: kButtonBody1TextStyle.copyWith(
  //                               color: Colors.white,
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                       SizedBox(width: 16.0),
  //                       Flexible(
  //                         child: GradientButton(
  //                           onPressed: () {
  //                             Navigator.pushNamed(context, LoginScreen.id);
  //                           },
  //                           backgroundFill: GradientColor(
  //                             Colors.white,
  //                           ),
  //                           borderRadius: BorderRadius.circular(8.0),
  //                           padding: EdgeInsets.symmetric(
  //                             vertical: 16.0,
  //                             horizontal: 24.0,
  //                           ),
  //                           child: Text(
  //                             'Login',
  //                             style: kButtonBody1TextStyle.copyWith(
  //                               color: Colors.black,
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

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
                Text(
                  'ByteCare',
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
                  primaryColor: kThemePrimaryBlue,
                  items: <InformationCarouselItem>[
                    InformationCarouselItem(
                      illustration: UnDrawIllustration.security,
                      title: 'Safety',
                      description:
                          'We work hard to ensure that our application '
                          'incorporates top security measures to protect your '
                          'data.',
                    ),
                    InformationCarouselItem(
                      illustration: UnDrawIllustration.security,
                      title: 'Safety',
                      description:
                          'We work hard to ensure that our application '
                          'incorporates top security measures to protect your '
                          'data.',
                    ),
                    InformationCarouselItem(
                      illustration: UnDrawIllustration.security,
                      title: 'Safety',
                      description:
                          'We work hard to ensure that our application '
                          'incorporates top security measures to protect your '
                          'data.',
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
