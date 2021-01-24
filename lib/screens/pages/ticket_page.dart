import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';

/* Project-level Imports */
// Theme
import '../../theme/themes.dart';
import '../../theme/text.dart';
import '../../theme/colors.dart';
import '../../theme/gradients.dart';

// Utils
import '../../utils/color.dart';

// Data Models
import '../../models/patient.dart';
import '../../models/gradient_color.dart';
import '../../models/processing_dialog_theme.dart';

// Controllers
import '../../controllers/processing_view.dart';

// Interfaces
import '../../interfaces/application_page.dart';

// Providers
import '../../providers/byte_care_api_notifier.dart';

// Services
import '../../services/byte_care_api.dart';

// Widgets
import '../../widgets/gradient_background.dart';
import '../../widgets/processing_dialog.dart';

class TicketPage extends StatefulWidget implements ApplicationPage {
  final IconData _fabIcon;
  final void Function() _fabPressed;

  TicketPage({IconData fabIcon, void Function() fabPressed})
      : _fabIcon = fabIcon,
        _fabPressed = fabPressed;

  @override
  _TicketPageState createState() => _TicketPageState();

  @override
  Widget asWidget() => this;

  @override
  IconData getFabIcon() => _fabIcon;

  @override
  void Function() getFabPressed() => _fabPressed;

  @override
  get usesFab => _fabIcon != null && _fabPressed != null;
}

class _TicketPageState extends State<TicketPage> {
  ProcessingViewController _processState;
  PatientModel _selectedPatient;

  ByteCareApiNotifier _getApiNotifier(BuildContext context, [bool listen]) =>
      Provider.of(context, listen: listen);

  @override
  void initState() {
    _processState = ProcessingViewController(
      modalBuilder: (data, content, message) => Stack(
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
                  showWave: data.waveColor != null,
                  waveColor: data.waveColor,
                ),
              ),
            ),
          ),
        ],
      ),
      successData: ProcessingDialogThemeModel(
        color: kThemeColorSuccess,
        icon: CircleAvatar(
          backgroundColor: darken(kThemeColorSuccess, 65),
          child: Icon(LineAwesomeIcons.check, color: Colors.white),
        ),
      ),
      errorData: ProcessingDialogThemeModel(
        color: kThemeColorError,
        icon: CircleAvatar(
          backgroundColor: darken(kThemeColorError, 65),
          child: Icon(LineAwesomeIcons.check, color: Colors.white),
        ),
      ),
      loadingData: ProcessingDialogThemeModel(
        color: kThemeColorPrimary,
        waveColor: kThemeColorSecondary,
        message: '''We're getting your ticker data, please wait.''',
        icon: CircleAvatar(
          backgroundColor: darken(kThemeColorPrimary, 65),
          child: Icon(LineAwesomeIcons.check, color: Colors.white),
        ),
      ),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      theme: kByteCareThemeData,
      background: GradientColorModel(kThemeGradientPrimaryAngled),
      ignoreSafeArea: false,
      child: _processState.build(_buildContent()),
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: 16.0,
            horizontal: 16.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Showing appointment for',
                style: kSubtitle1TextStyle.copyWith(
                  color: Colors.white.withOpacity(.9),
                ),
              ),
              DropdownButtonFormField<PatientModel>(
                value: _selectedPatient,
                onChanged: (patient) {
                  if (patient != _selectedPatient) {
                    _selectedPatient = patient;
                  }
                },
                items: _getApiNotifier(context, true).patients.map((e) {
                  return DropdownMenuItem<PatientModel>(
                    child: Text(
                      '${e.name} ${e.surname}',
                      style: kButtonBody1TextStyle,
                    ),
                  );
                }).toList(),
              ),
              Text(
                _selectedPatient.name,
                style: kTitle1TextStyle.copyWith(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            height: double.infinity,
            padding: EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0, 1.0),
                  blurRadius: 16.0,
                ),
              ],
            ),
            child: _buildTicketData(
              'Groote Schuur Hospital',
              '2020-01-29 '
                  '12:18:36',
              'Not yet completed',
              'Stomach Bug',
            ),
          ),
        ),
      ],
    );
  }

  Column _buildTicketData(String hospitalName, String datetime,
      String completionStatus, String reason) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              hospitalName,
              style: kBody1TextStyle,
            ),
          ],
        ),
        SizedBox(height: 16.0),
        Text(
          datetime,
          style: kBody1TextStyle,
        ),
        SizedBox(height: 16.0),
        Text(
          completionStatus,
          style: kBody1TextStyle,
        ),
        SizedBox(height: 16.0),
        Expanded(
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(24.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Reason for Visit',
                  textAlign: TextAlign.start,
                  style: kSubtitle1TextStyle,
                ),
                SizedBox(height: 8.0),
                RichText(
                  text: TextSpan(
                    text: reason,
                    style: kBody1TextStyle,
                  ),
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 80.0),
      ],
    );
  }
}
