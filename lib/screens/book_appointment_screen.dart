import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:enum_to_string/enum_to_string.dart';

/* Project-level Imports */
// Theme
import '../theme/themes.dart';
import '../theme/text.dart';
import '../theme/colors.dart';
import '../theme/gradients.dart';
import '../theme/form.dart';

// Utils
import '../utils/color.dart';

// Data Models
import '../models/appointment.dart';
import '../models/gradient_color.dart';
import '../models/hospital.dart';
import '../models/patient.dart';
import '../models/processing_dialog_theme.dart';

// Utils
import '../utils/time.dart';

// Controllers
import '../controllers/account.dart';
import '../controllers/processing_view.dart';

// Widgets
import '../widgets/date_time_form_field.dart';
import '../widgets/gradient_background.dart';
import '../widgets/gradient_button.dart';
import '../widgets/processing_dialog.dart';

class BookAppointmentScreen extends StatefulWidget {
  static const id = 'book_appointment_screen';

  @override
  _BookAppointmentScreenState createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  TextEditingController _reasonController = TextEditingController();
  HospitalModel _passedHospital;
  PatientModel _selectedPatient;
  DateTime _selectedDateTime = DateTime.now();
  WardType _selectedWardType;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  ProcessingViewController _processState;
  DateFormat _timeFormatter = DateFormat('h:mm a');

  T _getProvider<T>(BuildContext context, [bool listen = false]) =>
      Provider.of<T>(context, listen: listen);

  @override
  void initState() {
    super.initState();

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
  }

  @override
  Widget build(BuildContext context) {
    if (_passedHospital == null) {
      _passedHospital =
          ModalRoute.of(context).settings.arguments as HospitalModel;

      if (_passedHospital == null) {
        Navigator.pop(context);
      }
    }

    if (_getProvider<AccountController>(context).availablePatients.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((timestamp) {
        showDialog(
          context: context,
          builder: (context) => _buildNoPatientsContent(),
        );
      });
    }

    return GradientBackground(
      theme: kByteCareThemeData,
      background: GradientColorModel(kThemeGradientPrimaryAngled),
      ignoreSafeArea: true,
      child: _processState.build(_buildContent(context)),
    );
  }

  Widget _buildNoPatientsContent() {
    return IntrinsicHeight(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'No Patients',
                  style: kTitle2TextStyle,
                ),
                SizedBox(height: 16.0),
                Text(
                  'Couldn\'t find any patients for you to use.',
                  style: kBody1TextStyle,
                ),
                SizedBox(height: 8.0),
                Text(
                  'Create a new patient or wait until one of your other '
                  'appointments are complete.',
                  style: kBody1TextStyle,
                ),
                SizedBox(height: 24.0),
                IntrinsicWidth(
                  child: GradientButton(
                    onPressed: () {
                      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                        Navigator.pop(this.context);
                        Navigator.pop(this.context);
                      });
                    },
                    background:
                        GradientColorModel(kButtonBackgroundLinearGradient),
                    borderRadius: BorderRadius.circular(8.0),
                    padding: const EdgeInsets.symmetric(
                      vertical: 16.0,
                      horizontal: 24.0,
                    ),
                    child: Text(
                      'Go Back',
                      style: kButtonBody1TextStyle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Scaffold _buildContent(BuildContext context) {
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
                  'Appointment',
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
        width: double.infinity,
        height: double.infinity,
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 24.0,
                  ),
                  child: Column(
                    children: [
                      FormField<PatientModel>(builder: (state) {
                        return InputDecorator(
                          decoration: kFormFieldInputDecoration.copyWith(
                            labelText: 'Select a Patient',
                          ),
                          child: Consumer<AccountController>(
                            builder: (context, controller, child) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: controller.availablePatients.map((e) {
                                  return Material(
                                    borderRadius: BorderRadius.circular(8.0),
                                    color: _selectedPatient == e
                                        ? kThemeColorPrimary
                                        : Colors.white,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(8.0),
                                      onTap: () {
                                        setState(() {
                                          if (_selectedPatient != e) {
                                            _selectedPatient = e;
                                          }
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12.0,
                                          horizontal: 16.0,
                                        ),
                                        child: Text(
                                          e.fullName,
                                          style: kButtonBody1TextStyle.copyWith(
                                            color: _selectedPatient == e
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              );
                            },
                          ),
                        );
                      }),
                      SizedBox(height: kFormFieldSpacing),
                      TextFormField(
                        readOnly: true,
                        initialValue: _passedHospital.name,
                        decoration: kFormFieldInputDecoration.copyWith(
                          labelText: 'Hospital',
                        ),
                      ),
                      SizedBox(height: kFormFieldSpacing),
                      DateTimeFormField(
                        decoration: kFormFieldInputDecoration.copyWith(
                          labelText: 'Appointment Date',
                        ),
                        onlyDate: true,
                        initialValue: DateTime.now(),
                        firstDate: DateTime(
                          DateTime.now().year,
                          DateTime.now().month,
                          DateTime.now().day,
                        ),
                        onSaved: (datetime) {
                          _selectedDateTime = DateTime(
                            datetime.year,
                            datetime.month,
                            datetime.day,
                            _selectedDateTime.hour,
                            _selectedDateTime.minute,
                            _selectedDateTime.second,
                            0,
                            0,
                          );
                        },
                      ),
                      SizedBox(height: 8.0),
                      FormField<DateTime>(builder: (state) {
                        return InputDecorator(
                          decoration: kFormFieldInputDecoration,
                          child: SizedBox(
                            height: 128.0,
                            child: GridView.count(
                              scrollDirection: Axis.vertical,
                              crossAxisCount: 3,
                              crossAxisSpacing: 4.0,
                              mainAxisSpacing: 4.0,
                              childAspectRatio: 5 / 2,
                              children: rangeDate(
                                DateTime(0, 0, 0, 8, 0, 0),
                                Duration(minutes: 30),
                                19,
                              ).map<Widget>((e) {
                                return Material(
                                  borderRadius: BorderRadius.circular(8.0),
                                  color: isSelectedTime(e)
                                      ? kThemeColorPrimary
                                      : Colors.grey.shade100,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(8.0),
                                    onTap: () {
                                      setState(() {
                                        _selectedDateTime = DateTime(
                                          _selectedDateTime.year,
                                          _selectedDateTime.month,
                                          _selectedDateTime.day,
                                          e.hour,
                                          e.minute,
                                          e.second,
                                        );
                                      });
                                    },
                                    child: Center(
                                      child: Text(
                                        _timeFormatter.format(e),
                                        textAlign: TextAlign.center,
                                        style: kButtonBody1TextStyle.copyWith(
                                          color: isSelectedTime(e)
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        );
                      }),
                      SizedBox(height: kFormFieldSpacing),
                      FormField<WardType>(builder: (state) {
                        return InputDecorator(
                          decoration: kFormFieldInputDecoration.copyWith(
                            labelText: 'Ward Type',
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: WardType.values.map((e) {
                              return Material(
                                borderRadius: BorderRadius.circular(8.0),
                                color: _selectedWardType == e
                                    ? kThemeColorPrimary
                                    : Colors.white,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      if (_selectedWardType != e) {
                                        _selectedWardType = e;
                                      }
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12.0,
                                      horizontal: 16.0,
                                    ),
                                    child: Text(
                                      EnumToString.convertToString(e,
                                          camelCase: true),
                                      style: kButtonBody1TextStyle.copyWith(
                                        color: _selectedWardType == e
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        );
                      }),
                      SizedBox(height: kFormFieldSpacing),
                      TextFormField(
                        maxLines: null,
                        minLines: 1,
                        controller: _reasonController,
                        keyboardType: TextInputType.multiline,
                        decoration: kFormFieldInputDecoration.copyWith(
                          labelText: 'Reason for Visit',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(24.0),
        color: Colors.white,
        child: IntrinsicHeight(
          child: GradientButton(
            onPressed: _bookAppointment,
            background: GradientColorModel(kButtonBackgroundLinearGradient),
            borderRadius: BorderRadius.circular(8.0),
            padding: const EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 24.0,
            ),
            child: Text(
              'Book my Appointment',
              style: kButtonBody1TextStyle,
            ),
          ),
        ),
      ),
    );
  }

  void _bookAppointment() async {
    setState(() {
      _processState.begin();
    });

    var result =
        await _getProvider<AccountController>(this.context).bookAppointment(
      AppointmentModel(
        id: '',
        patientSelected: _selectedPatient,
        hospitalSelected: _passedHospital,
        date: _selectedDateTime,
        wardType: _selectedWardType,
        reason: _reasonController.text,
      ),
    );

    if (result.code == 200) {
      setState(() {
        _processState.complete(result.code, 'Successfully Booked Appointment');
      });

      await Future.delayed(kProcessDelayDuration);

      setState(() {
        _processState.reset();
      });

      Navigator.pop(this.context);
    } else {
      setState(() {
        _processState.completeWithError(
          result.code,
          result.message,
        );
      });

      await Future.delayed(kProcessErrorDelayDuration);

      setState(() {
        _processState.reset();
      });
    }
  }

  bool isSelectedTime(DateTime time) {
    if (_selectedDateTime == null) return false;

    return _selectedDateTime.hour == time.hour &&
        _selectedDateTime.minute == time.minute &&
        _selectedDateTime.second == time.second;
  }
}
