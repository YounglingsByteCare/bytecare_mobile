import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/* Project-level Imports */
// Theme
import '../theme/themes.dart';
import '../theme/text.dart';
import '../theme/colors.dart';
import '../theme/gradients.dart';
import '../theme/form.dart';

// Data Models
import '../models/gradient_color.dart';
import '../models/hospital.dart';
import '../models/patient.dart';

// Providers
import '../providers/byte_care_api_notifier.dart';

// Widgets
import '../widgets/date_time_form_field.dart';
import '../widgets/gradient_background.dart';
import '../widgets/gradient_button.dart';

class BookAppointmentScreen extends StatefulWidget {
  static const id = 'book_appointment_screen';

  @override
  _BookAppointmentScreenState createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  HospitalModel _passedHospital;
  PatientModel _selectedPatient;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  DateTime _selectedDateTime = DateTime.now();

  ByteCareApiNotifier _getApiNotifier(context, [listen = false]) =>
      Provider.of<ByteCareApiNotifier>(context, listen: listen);

  @override
  void initState() {
    super.initState();
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

    var patients = _getApiNotifier(context).patients;

    return GradientBackground(
      theme: kByteCareThemeData,
      background: GradientColorModel(kThemeGradientPrimaryAngled),
      ignoreSafeArea: true,
      child: Scaffold(
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
                            child: Column(
                              children: patients.map((e) {
                                return RadioListTile(
                                  groupValue: _selectedPatient,
                                  value: e,
                                  title: Text('e.name', style: kBody1TextStyle),
                                  onChanged: (item) {
                                    if (item != _selectedPatient) {
                                      setState(() => _selectedPatient = item);
                                    }
                                  },
                                );
                              }).toList(),
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
                            labelText: 'Appointment Date & Time',
                          ),
                          initialValue: DateTime.now(),
                          firstDate: DateTime(
                            DateTime.now().year,
                            DateTime.now().month,
                            DateTime.now().day,
                          ),
                        ),
                        SizedBox(height: kFormFieldSpacing),
                        TextFormField(
                          maxLines: null,
                          minLines: 1,
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
              onPressed: () {},
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
      ),
    );
  }
}
