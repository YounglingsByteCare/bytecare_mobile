import 'package:bytecare_mobile/models/hospital_marker.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

/* Project-level Imports */
// Constants
import '../constants/theme.dart';

// Data Models
import '../models/gradient_color.dart';
import '../models/hospital_marker.dart';

// Widgets
import '../widgets/gradient_background.dart';

class BookAppointmentScreen extends StatefulWidget {
  static const id = 'book_appointment_screen';

  @override
  _BookAppointmentScreenState createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  HospitalMarker _passedMarker;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      _passedMarker =
          ModalRoute.of(context).settings.arguments as HospitalMarker;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      themeData: kByteCareThemeData,
      backgroundFill: GradientColor(kThemePrimaryAngledLinearGradient),
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
                        TextFormField(
                          readOnly: true,
                          initialValue: _passedMarker.hospitalName,
                          decoration: kFormFieldInputDecoration.copyWith(
                            labelText: 'Hospital',
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                readOnly: true,
                                initialValue: DateTime.now().toString(),
                              ),
                            ),
                          ],
                        ),
                      ],
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
}
