import 'package:bytecare_mobile/widgets/gradient_button.dart';
import 'package:flutter/material.dart';

/* Project-level Imports */
// Theme
import '../theme/themes.dart';
import '../theme/text.dart';
import '../theme/gradients.dart';
import '../theme/form.dart';

// Data Models
import '../models/gradient_color.dart';

// Services
import '../services/byte_care_api.dart';

// Widgets
import '../widgets/gradient_background.dart';

// Screens
import '../screens/errors/connection_failed.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static const String id = 'forgot_password_screen';

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController _emailController = TextEditingController();
  int _currentStep = 0;

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
                currentStep: _currentStep,
                steps: [
                  Step(
                    title: Text('Get your token'),
                    content: Column(
                      children: [
                        TextField(
                          controller: _emailController,
                          decoration: kFormFieldInputDecoration.copyWith(
                              labelText: 'Email Address'),
                        ),
                        SizedBox(height: 16.0),
                        GradientButton(
                          borderRadius: BorderRadius.circular(8.0),
                          padding: const EdgeInsets.symmetric(
                            vertical: 16.0,
                            horizontal: 24.0,
                          ),
                          onPressed: () async {
                            var api = ByteCareApi.getInstance();
                            var result;

                            try {
                              result = await api
                                  .forgotPassword(_emailController.text);
                            } on ServerNotAvailableException {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ConnectionFailed(widget),
                                ),
                              );
                            }

                            if (result.code == 200) {
                              setState(() {
                                _currentStep++;
                              });
                            }
                          },
                          child: Text(
                            'Send Email',
                            style: kButtonBody1TextStyle,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Step(
                    title: Text('Verification'),
                    subtitle: Text('Enter the code that we sent you'),
                    content: Column(
                      children: [
                        TextField(
                          controller: _emailController,
                          decoration: kFormFieldInputDecoration.copyWith(
                              labelText: 'Password'),
                        ),
                        SizedBox(height: 16.0),
                        GradientButton(
                          borderRadius: BorderRadius.circular(8.0),
                          padding: const EdgeInsets.symmetric(
                            vertical: 16.0,
                            horizontal: 24.0,
                          ),
                          onPressed: () async {
                            var api = ByteCareApi.getInstance();
                            var result;

                            try {
                              result = await api
                                  .forgotPassword(_emailController.text);
                            } on ServerNotAvailableException {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ConnectionFailed(widget),
                                ),
                              );
                            }

                            if (result.code == 200) {
                              setState(() {
                                _currentStep++;
                              });
                            }
                          },
                          child: Text(
                            'Check my Code',
                            style: kButtonBody1TextStyle,
                          ),
                        ),
                        SizedBox(height: 32.0),
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
