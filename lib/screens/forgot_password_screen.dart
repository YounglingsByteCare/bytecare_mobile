import 'package:flutter/material.dart';

/* Project-level Imports */
// Constants
import '../theme/themes.dart';
import '../theme/text.dart';
import '../theme/gradients.dart';
// Data Models
import '../models/gradient_color.dart';
// Widgets
import '../widgets/gradient_background.dart';

class ForgotPasswordScreen extends StatelessWidget {
  static const String id = 'forgot_password_screen';

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      theme: kByteCareThemeData,
      background: GradientColorModel(kThemeGradientPrimaryAngled),
      ignoreSafeArea: true,
      child: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
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
                  'Password Recovery',
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
              offset: Offset(0, 1),
              blurRadius: 16.0,
            ),
          ],
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stepper(
                steps: [
                  Step(
                    title: Text('Identify yourself'),
                    subtitle: Text('Enter you email address'),
                    content: Column(
                      children: [
                        TextField(),
                        TextField(),
                      ],
                    ),
                  ),
                  Step(
                    title: Text('Verification'),
                    subtitle: Text('Enter the code that we sent you'),
                    content: Column(
                      children: [
                        Text('Didn\'nt get the code? Click here'),
                      ],
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
