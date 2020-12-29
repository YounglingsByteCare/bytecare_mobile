import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/* Project-level Import */
// Constants
import '../constants/theme.dart';

// Utils
import '../utils/color.dart';

// Data Models
import '../models/registration_step.dart';

// Widgets
import '../widgets/gradient_button.dart';

class RegistrationStepper extends StatefulWidget {
  List<RegistrationStep> steps;
  int dotCount;
  int activeStep;

  Function showTermsAndConditionModal;
  Function showPrivacyPolicyModal;

  RegistrationStepper({
    @required this.steps,
    this.dotCount = 5,
    this.activeStep,
  });

  @override
  _RegistrationStepperState createState() => _RegistrationStepperState();
}

class _RegistrationStepperState extends State<RegistrationStepper> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _buildIcons(),
          ),
          SizedBox(height: 16.0),
          widget.steps[widget.activeStep].content,
        ],
      ),
    );
  }

  List<Widget> _buildIcons() {
    List<Widget> out = [];

    for (int i = 0; i < widget.steps.length; i++) {
      RegistrationStep data = widget.steps[i];

      bool isComplete = widget.activeStep > i;
      bool isActive = widget.activeStep == i;

      Widget result = Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: isComplete ? kThemeSuccessColor : Colors.grey.shade500,
          ),
        ),
        child: Stack(
          children: <Widget>[
            isComplete
                ? Positioned.fill(
                    child: Container(
                      padding: EdgeInsets.all(24.0),
                      decoration: BoxDecoration(
                        color: brighten(kThemeSuccessColor, 90),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  )
                : isActive
                    ? Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        height: 32.0,
                        child: Container(
                          padding: EdgeInsets.all(24.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(16.0),
                              bottomLeft: Radius.circular(8.0),
                              bottomRight: Radius.circular(8.0),
                            ),
                          ),
                        ),
                      )
                    : Container(),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: isComplete
                  ? Icon(
                      Icons.done_all,
                      color: kThemeSuccessColor,
                    )
                  : Icon(data.icon),
            ),
          ],
        ),
      );

      out.add(result);

      if (i < widget.steps.length - 1) {
        Widget dots = Row(
          children: List<Widget>.generate(
            widget.dotCount,
            (index) => Container(
              width: 2.0,
              height: 2.0,
              margin: EdgeInsets.all(4.0),
              color: Colors.grey.shade700,
            ),
          ),
        );

        out.add(dots);
      }
    }

    return out;
  }
}
