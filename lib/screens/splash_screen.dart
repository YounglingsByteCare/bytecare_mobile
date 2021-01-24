import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/* Project-level Imports */
// Theme
import '../theme/colors.dart';
import '../theme/text.dart';

// Models
import '../models/appointment.dart';
import '../models/hospital.dart';
import '../models/patient.dart';

// Controllers
import '../controllers/hospital_marker.dart';

// Providers
import '../providers/byte_care_api_notifier.dart';

// Services
import '../services/auth_storage.dart';
import '../services/byte_care_api.dart';

// Screens
import 'application_screen.dart';
import 'book_appointment_screen.dart';
import 'landing_screen.dart';
import 'login_screen.dart';
import 'pages/clinic_page.dart';

class SplashScreen extends StatelessWidget {
  static const id = 'splash_screen';

  BuildContext _context;

  @override
  Widget build(BuildContext context) {
    this._context = context;

    return AnimatedSplashScreen.withScreenFunction(
      splashIconSize: 250.0,
      splash: _buildSplashContent(),
      screenFunction: _splashInit,
    );
  }

  Widget _buildSplashContent() {
    return Column(
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Byte',
                style: kTitle1TextStyle.copyWith(color: kThemeColorPrimary),
              ),
              TextSpan(
                text: 'Care',
                style: kTitle1TextStyle.copyWith(color: kThemeColorSecondary),
              ),
            ],
          ),
        ),
        SizedBox(height: 24.0),
        SpinKitWave(color: kThemeColorPrimary),
      ],
    );
  }

  ByteCareApiNotifier _getApiNotifier(BuildContext context,
          [bool listen = false]) =>
      Provider.of<ByteCareApiNotifier>(context, listen: listen);

  Future<Widget> _splashInit() async {
    var store = AuthStorage.getInstance();
    var prefs = await SharedPreferences.getInstance();
    var api = ByteCareApi.getInstance();

    _getApiNotifier(_context).setHospitalController(
      HospitalMarkerController.withUser(
        userMarker: Marker(
          markerId: MarkerId(''),
          infoWindow: InfoWindow(
            title: 'You',
            snippet: 'Your Location',
          ),
        ),
      ),
    );

    if (await store.hasLoginToken) {
      prefs.setBool('is_first_run', true);
      store.retrieveLoginToken().then((value) async {
        _getApiNotifier(this._context).authToken = value;

        List<dynamic> apiHospitals = (await api.getHospitals(value)).data;
        var hospitals = apiHospitals.map((e) {
          return HospitalModel(
            id: e['_id']['\$oid'],
            name: e['hospital_name'],
            location: LatLng(e['point'][0], e['point'][1]),
          );
        });

        _getApiNotifier(this._context)
            .hospitalController
            .addHospitals(hospitals);

        List<dynamic> apiPatients = (await api.getPatients(value)).data;

        print('Patients: $apiPatients');

        _getApiNotifier(this._context)
            .initPatients(apiPatients.map<PatientModel>(
          (e) {
            return PatientModel.parse(e);
          },
        ));

        List<dynamic> apiAppointments = (await api.getAppointments(value)).data;
        _getApiNotifier(this._context)
            .initAppointments(apiAppointments.map<AppointmentModel>(
          (e) {
            return AppointmentModel.parse(e);
          },
        ));
        // api.getHospitals(token);
        // api.getPatients(token);
        // api.getAppointments(token);
      });

      return ApplicationScreen();
    } else {
      if (prefs.containsKey('is_first_run')) {
        var value = !prefs.getBool('is_first_run');
        if (value) {
          return LoginScreen();
        } else {
          prefs.setBool('is_first_run', true);
          return LandingScreen();
        }
      } else {
        prefs.setBool('is_first_run', true);
        return LandingScreen();
      }
    }
  }
}
