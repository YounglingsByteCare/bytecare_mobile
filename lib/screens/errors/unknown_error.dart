import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:ms_undraw/ms_undraw.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

/* Project-level Imports */
// Theme
import '../../theme/text.dart';
import '../../theme/colors.dart';

// Data Models
import '../../models/gradient_color.dart';

// Widgets
import '../../widgets/gradient_button.dart';

class UnknownError extends StatefulWidget {
  final Exception error;

  UnknownError(this.error);

  @override
  _UnknownErrorState createState() => _UnknownErrorState();
}

class _UnknownErrorState extends State<UnknownError> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kThemeColorPrimary,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AspectRatio(
              aspectRatio: 10 / 9,
              child: UnDraw(
                illustration: UnDrawIllustration.blank_canvas,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 32.0),
            Text(
              'An unknown error has occurred',
              style: kTitle1TextStyle.copyWith(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.0),
            Text(
              'We\'re not sure what the problem is, but we\'re always working '
              'hard to ensure that any problems that are reported are '
              'dealt with as soon as possible.',
              style: kBody1TextStyle.copyWith(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.0),
            GradientButton(
              onPressed: () async {
                setState(() {
                  _isLoading = true;
                });

                final Email email = Email(
                  body: _emailErrorMessage,
                  subject: 'ByteCare Error Report: Unknown Error',
                  recipients: ['bytecare01@gmail.com'],
                  isHTML: false,
                );

                await FlutterEmailSender.send(email);

                setState(() {
                  _isLoading = false;
                });
              },
              background: GradientColorModel(Colors.white),
              borderRadius: BorderRadius.circular(8.0),
              padding: EdgeInsets.symmetric(
                vertical: 16.0,
                horizontal: 24.0,
              ),
              child: AnimatedCrossFade(
                duration: Duration(milliseconds: 250),
                alignment: Alignment.center,
                crossFadeState: _isLoading
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                firstChild: Text(
                  'Report the Error',
                  style: kButtonBody1TextStyle.copyWith(color: Colors.black),
                ),
                secondChild: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: IntrinsicWidth(
                    child: SpinKitDualRing(
                      color: kThemeColorPrimary,
                      size: kButtonBody1TextStyle.fontSize,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String get _emailErrorMessage => '''
  <Enter extra information here>
  
  ${widget.error}
  ''';
}
