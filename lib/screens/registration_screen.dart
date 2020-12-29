import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:im_stepper/stepper.dart';

/* My Imports */
// Constants
import '../constants/theme.dart';
import '../constants/input_fields.dart';

// Utils
import '../utils/color.dart';

// Data Models
import '../models/registration_step.dart';

// Widgets
import '../widgets/gradient_button.dart';
import '../widgets/registration_stepper.dart';

// Screens
import 'registration_steps/basic_info.dart';
import 'registration_steps/phone_number.dart';
import 'registration_steps/address.dart';

class RegistrationScreen extends StatefulWidget {
  static String id = 'registration_screen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  int _activeStep = 0;

  List<RegistrationStep> regSteps = [
    RegistrationStep(
      icon: Icons.fingerprint,
      content: RegistrationStepBasicInfo(),
    ),
    RegistrationStep(
      icon: Icons.phone_android,
      content: RegistrationStepPhoneNumber(),
    ),
    RegistrationStep(
      icon: Icons.map,
      content: RegistrationStepAddress(),
    ),
  ];

  void showTermsAndConditionModal() {}

  void showPrivacyPolicyModal() {}

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
            appBar: AppBar(
              leading: Navigator.canPop(context)
                  ? IconButton(
                      icon: Icon(
                        Icons.chevron_left,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )
                  : null,
              title: Text(
                'Go Back',
                style: kBodyTextStyle,
              ),
            ),
            body: RegistrationStepper(
              steps: regSteps,
              activeStep: _activeStep,
            ),
            bottomNavigationBar: Container(
              padding: EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.black38,
                    width: 0.5,
                  ),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text.rich(
                    TextSpan(
                      children: <InlineSpan>[
                        TextSpan(
                            text: 'By clicking the following, you '
                                'accept our'
                                ' '),
                        TextSpan(
                          text: 'Terms & Conditions',
                          style: TextStyle(color: Colors.blueAccent),
                          recognizer: TapGestureRecognizer()
                            ..onTap = showTermsAndConditionModal,
                        ),
                        TextSpan(text: ' and that you have read our '),
                        TextSpan(
                          text: 'Privacy Policy',
                          style: TextStyle(color: Colors.blueAccent),
                          recognizer: TapGestureRecognizer()
                            ..onTap = showPrivacyPolicyModal,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 12.0),
                  Row(
                    children: [
                      _activeStep > 0
                          ? GradientButton(
                              onPressed: () {
                                if (_activeStep > 0) {
                                  _activeStep--;
                                }
                              },
                              backgroundFill: GradientColor(Colors.white),
                              borderRadius: BorderRadius.circular(4.0),
                              borderSide: GradientBorderSide(
                                borderFill: GradientColor(
                                  kButtonBackgroundLinearGradient,
                                ),
                                width: 0.0,
                              ),
                              elevation: 1.0,
                              padding: EdgeInsets.symmetric(
                                vertical: 12.0,
                                horizontal: 12.0,
                              ),
                              child: Icon(Icons.arrow_back),
                            )
                          : Container(),
                      SizedBox(width: 16.0),
                      Flexible(
                        flex: 3,
                        child: GradientButton(
                          onPressed: () {
                            if (_activeStep < regSteps.length - 1) {
                              _activeStep++;
                            }
                          },
                          backgroundFill: GradientColor(
                            kButtonBackgroundLinearGradient,
                          ),
                          borderRadius: BorderRadius.circular(4.0),
                          borderSide: GradientBorderSide.zero,
                          shadowColor: Colors.black.withAlpha(50),
                          elevation: 1.0,
                          padding: EdgeInsets.symmetric(
                            vertical: 12.0,
                            horizontal: 16.0,
                          ),
                          child: Text(
                            'Next Step',
                            style: kButtonBody1TextStyle.copyWith(
                              color: Colors.white,
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
      ),
    );
  }
}
