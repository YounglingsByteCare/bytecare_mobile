import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

/* My Imports */
// Constants
import '../../constants/theme.dart';
import '../../constants/input_fields.dart';

// Utils
import '../../utils/color.dart';

/* Project-level Imports */
// Widgets
import '../../widgets/gradient_button.dart';

class RegistrationStepBasicInfo extends StatefulWidget {
  final GlobalKey<FormState> registrationFormKey;

  RegistrationStepBasicInfo([formKey])
      : registrationFormKey =
            formKey != null ? formKey : GlobalKey<FormState>();

  GlobalKey<FormState> get formKey => registrationFormKey;

  @override
  State<RegistrationStepBasicInfo> createState() =>
      _RegistrationStepBasicInfoState();
}

class _RegistrationStepBasicInfoState extends State<RegistrationStepBasicInfo> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Proceed with your',
          textAlign: TextAlign.start,
          style: kSubtitleTextStyle,
        ),
        Text(
          'Basic Information',
          textAlign: TextAlign.start,
          style: kTitle1TextStyle,
        ),
        SizedBox(height: 32.0),
        Form(
          // Form that houses all of the registration input fields.
          key: widget.registrationFormKey,
          child: Column(
            children: <Widget>[
              textInputFieldBuilder(
                kFormFieldInputDecoration.copyWith(
                  labelText: 'Full Name',
                  hintText: 'John Doe',
                ),
              ),
              SizedBox(height: 16.0),
              emailInputFieldBuilder(kFormFieldInputDecoration.copyWith(
                  labelText: 'Email Address', hintText: 'john@company.com')),
              SizedBox(height: 16.0),
              passwordInputFieldBuilder(
                kFormFieldInputDecoration.copyWith(
                  labelText: 'Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
                _isPasswordVisible,
              ),
              SizedBox(height: 16.0),
            ],
          ),
        ),
      ],
    );
  }
}
