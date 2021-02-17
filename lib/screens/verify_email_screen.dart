import 'package:bytecare_mobile/theme/gradients.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

/* Project-level Imports */
// Theme
import '../theme/themes.dart';
import '../theme/text.dart';
import '../theme/colors.dart';

// Utils
import '../utils/color.dart';

// Data Models
import '../models/gradient_color.dart';
import '../models/processing_dialog_theme.dart';

// Controllers
import '../controllers/processing_view.dart';

// Widgets
import '../widgets/gradient_background.dart';
import '../widgets/processing_dialog.dart';

class VerifyEmailScreen extends StatefulWidget {
  static String id = 'verify_email_screen';

  @override
  _VerifyEmailScreenState createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  ProcessingViewController _processState;

  @override
  void initState() {
    _processState = ProcessingViewController(
      modalBuilder: (data, content, message) {
        return Stack(
          fit: StackFit.loose,
          alignment: AlignmentDirectional.center,
          children: [
            content,
            Positioned.fill(
              child: Material(
                color: Colors.black45,
                child: Align(
                  alignment: Alignment.center,
                  child: ProcessingDialog(
                    color: data.color,
                    icon: data.icon,
                    message: message,
                    showWave: false,
                    waveColor: data.waveColor,
                  ),
                ),
              ),
            ),
          ],
        );
      },
      successData: ProcessingDialogThemeModel(
        color: kThemeColorSuccess,
        message: 'We\'ve successfully got your data, now let\'s get to '
            'working.',
        icon: CircleAvatar(
          backgroundColor: darken(kThemeColorSuccess, 65),
          child: Icon(
            LineAwesomeIcons.check,
            color: Colors.white,
          ),
        ),
      ),
      errorData: ProcessingDialogThemeModel(
        color: kThemeColorError,
        message: 'There was an error when loading your data. Please try '
            'again.',
        icon: CircleAvatar(
          backgroundColor: darken(kThemeColorError, 65),
          child: Icon(
            LineAwesomeIcons.times,
            color: Colors.white,
          ),
        ),
      ),
      loadingData: ProcessingDialogThemeModel(
        color: kThemeColorPrimary,
        message: 'We\'re signing you in, enjoy your stay.',
        waveColor: kThemeColorSecondary,
        icon: SpinKitPulse(
          color: Colors.white,
        ),
      ),
    );

    super.initState();

    _processState.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      theme: kByteCareThemeData,
      background: GradientColorModel(kThemeGradientPrimaryAngled),
      ignoreSafeArea: true,
      child: _processState.build(_buildContent()),
    );
  }

  Widget _buildContent() {
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
                  'Create a new',
                  style: kSubtitle1TextStyle.copyWith(
                    color: Colors.white.withOpacity(.9),
                  ),
                ),
                Text(
                  'Patient',
                  style: kTitle1TextStyle.copyWith(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
