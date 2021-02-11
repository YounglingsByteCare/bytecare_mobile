import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:ms_undraw/ms_undraw.dart';
import 'package:intl/intl.dart';
import 'package:enum_to_string/enum_to_string.dart';

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
import '../../controllers/account.dart';
import '../../controllers/processing_view.dart';

// Interfaces
import '../../interfaces/application_page.dart';

// Widgets
import '../../widgets/gradient_background.dart';
import '../../widgets/gradient_button.dart';
import '../../widgets/processing_dialog.dart';

// Screens
import './clinic_page.dart';

class TicketPage extends StatefulWidget implements ApplicationPage {
  final IconData _fabIcon;
  final void Function(ApplicationPage) _fabPressed;
  final void Function(Type) _pageUpdater;
  ProcessingViewController processState;
  String appointmentId;

  PatientModel _selectedPatient;

  TicketPage({
    IconData fabIcon,
    void Function(ApplicationPage) fabPressed,
    void Function(Type) pageUpdater,
  })  : _fabIcon = fabIcon,
        _fabPressed = fabPressed,
        _pageUpdater = pageUpdater;

  @override
  _TicketPageState createState() => _TicketPageState();

  @override
  Widget asWidget() => this;

  @override
  IconData getFabIcon() => _fabIcon;

  @override
  void Function() getFabPressed() => () => _fabPressed(this);

  @override
  get usesFab => _fabIcon != null && _fabPressed != null;

  PatientModel get selectedPatient => _selectedPatient;
}

class _TicketPageState extends State<TicketPage> {
  final DateFormat _dateFormat = DateFormat.Md().add_jm();

  T _getProvider<T>(BuildContext context, [bool listen = false]) =>
      Provider.of<T>(context, listen: listen);

  @override
  void initState() {
    widget.processState = ProcessingViewController(
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
    widget.processState.addListener(() {
      setState(() {});
    });

    super.initState();

    if (_getProvider<AccountController>(this.context).hasAppointments() &&
        _getProvider<AccountController>(this.context).bookedPatients.isNotEmpty)
      widget._selectedPatient =
          _getProvider<AccountController>(this.context).bookedPatients.first;
  }

  @override
  Widget build(BuildContext context) {
    if (_getProvider<AccountController>(this.context).hasAppointments()) {
      if (widget._selectedPatient == null) {
        return GradientBackground(
          theme: kByteCareThemeData,
          background: GradientColorModel(kThemeGradientPrimaryAngled),
          ignoreSafeArea: false,
          child: widget.processState.build(_buildNoPatientSelectedContent()),
        );
      } else {
        return GradientBackground(
          theme: kByteCareThemeData,
          background: GradientColorModel(kThemeGradientPrimaryAngled),
          ignoreSafeArea: false,
          child: widget.processState.build(_buildTicketContent()),
        );
      }
    } else {
      return GradientBackground(
        theme: kByteCareThemeData,
        background: GradientColorModel(Colors.white),
        ignoreSafeArea: false,
        child: widget.processState.build(_buildEmptyContent()),
      );
    }
  }

  Widget _buildEmptyContent() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 24.0,
        left: 24.0,
        right: 24.0,
        bottom: 48.0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          AspectRatio(
            aspectRatio: 10 / 9,
            child: UnDraw(
              illustration: UnDrawIllustration.empty,
              color: kThemeColorPrimary,
            ),
          ),
          Text(
            'You haven\'t made any appointments, yet.',
            textAlign: TextAlign.center,
            style: kTitle2TextStyle,
          ),
          SizedBox(height: 32.0),
          IntrinsicWidth(
            child: GradientButton(
              onPressed: () {
                if (widget._pageUpdater != null)
                  widget._pageUpdater(ClinicPage);
              },
              borderRadius: BorderRadius.circular(8.0),
              background: GradientColorModel(kButtonBackgroundLinearGradient),
              padding: EdgeInsets.symmetric(
                vertical: 16.0,
                horizontal: 24.0,
              ),
              child: Text(
                'Book one now',
                style: kButtonBody1TextStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoPatientSelectedContent() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: 16.0,
            horizontal: 16.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              UnDraw(
                illustration: UnDrawIllustration.no_data,
                color: kThemeColorPrimary,
              ),
              SizedBox(height: 32.0),
              Text(
                'You haven\'t selected a patient.',
                textAlign: TextAlign.center,
                style: kTitle2TextStyle,
              ),
              SizedBox(height: 8.0),
              Text(
                'Please select a patient so that we can load an appointment.',
                textAlign: TextAlign.center,
                style: kBody1TextStyle,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTicketContent() {
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
              SizedBox(height: 16.0),
              Consumer<AccountController>(
                builder: (context, controller, child) {
                  return DropdownButtonFormField<PatientModel>(
                    decoration: InputDecoration(
                      prefixIcon: Icon(LineAwesomeIcons.user_tie),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    value: widget._selectedPatient,
                    onChanged: (patient) {
                      print('Patient Changed');
                      if (patient != widget._selectedPatient) {
                        print('Gonna update state');
                        setState(() {
                          widget._selectedPatient = patient;
                        });
                      }
                    },
                    items: controller.bookedPatients.map((e) {
                      return DropdownMenuItem<PatientModel>(
                        value: e,
                        child: Text(
                          '${e.name} ${e.surname}',
                          style: kButtonBody1TextStyle,
                        ),
                      );
                    }).toList(),
                  );
                },
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
            child: Consumer<AccountController>(
              builder: (context, controller, child) {
                var appointment = controller
                    .getAppointmentForPatient(widget._selectedPatient);

                widget.appointmentId = appointment.id;

                return _buildTicketData(
                  hospitalName: appointment.hospitalSelected.name,
                  datetime: _dateFormat.format(appointment.date),
                  wardType: EnumToString.convertToString(appointment.wardType),
                  completionStatus: 'Incomplete',
                  reason: appointment.reason,
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  _buildTicketData({
    String hospitalName,
    String datetime,
    String wardType,
    String completionStatus,
    String reason,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: TextEditingController(text: hospitalName),
          readOnly: true,
          style: kBody1TextStyle,
          decoration: InputDecoration(
            prefixIcon: Icon(LineAwesomeIcons.medical_clinic),
            suffixIcon: IconButton(
              onPressed: () async {
                _saveToClipboard(hospitalName);
              },
              icon: Icon(LineAwesomeIcons.clipboard),
            ),
            labelText: 'Hospital',
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
          ),
        ),
        SizedBox(height: 8.0),
        TextField(
          controller: TextEditingController(text: datetime),
          readOnly: true,
          style: kBody1TextStyle,
          decoration: InputDecoration(
            prefixIcon: Icon(LineAwesomeIcons.clock),
            suffixIcon: IconButton(
              onPressed: () async {
                _saveToClipboard(datetime);
              },
              icon: Icon(LineAwesomeIcons.clipboard),
            ),
            labelText: 'Date and Time',
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
          ),
        ),
        SizedBox(height: 8.0),
        TextField(
          controller: TextEditingController(text: wardType),
          readOnly: true,
          style: kBody1TextStyle,
          decoration: InputDecoration(
            prefixIcon: Icon(LineAwesomeIcons.clock),
            suffixIcon: IconButton(
              onPressed: () async {
                _saveToClipboard(wardType);
              },
              icon: Icon(LineAwesomeIcons.clipboard),
            ),
            labelText: 'Ward Type',
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
          ),
        ),
        SizedBox(height: 16.0),
        TextField(
          controller: TextEditingController(text: completionStatus),
          readOnly: true,
          style: kBody1TextStyle,
          decoration: InputDecoration(
            prefixIcon: Icon(LineAwesomeIcons.spinner),
            suffixIcon: IconButton(
              onPressed: () async {
                _saveToClipboard(completionStatus);
              },
              icon: Icon(LineAwesomeIcons.clipboard),
            ),
            labelText: 'Completion Status',
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
          ),
        ),
        SizedBox(height: 16.0),
        TextField(
          controller: TextEditingController(text: reason),
          readOnly: true,
          minLines: 1,
          maxLines: 6,
          textAlignVertical: TextAlignVertical.top,
          style: kBody1TextStyle,
          decoration: InputDecoration(
            // prefixIcon: Icon(LineAwesomeIcons.spinner),
            suffixIcon: IconButton(
              onPressed: () async {
                _saveToClipboard(reason);
              },
              icon: Icon(LineAwesomeIcons.clipboard),
            ),
            labelText: 'Reason for Visit',
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
          ),
        ),
        SizedBox(height: 80.0),
      ],
    );
  }

  void _saveToClipboard(String text) async {
    var data = ClipboardData(text: text);
    await Clipboard.setData(data);

    Scaffold.of(this.context).showSnackBar(
      SnackBar(
        content: Text('Successfully copied to clipboard.'),
      ),
    );
  }
}
