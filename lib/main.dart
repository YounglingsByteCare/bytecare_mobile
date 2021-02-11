import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/* Project-level Imports */
// Controllers
import 'controllers/account.dart';
import 'controllers/hospital_marker.dart';

// Services
import 'services/auth_storage.dart';
import 'services/byte_care_api.dart';

// Screens
import 'screens/application_screen.dart';
import 'screens/book_appointment_screen.dart';
import 'screens/create_patient_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/landing_screen.dart';
import 'screens/login_screen.dart';
import 'screens/registration_screen.dart';
import 'screens/splash_screen.dart';

final Uri apiHostUri = Uri(scheme: 'http', host: '10.0.0.108', port: 5000);

void main() {
  runApp(ByteCareMobile());
}

class ByteCareMobile extends StatelessWidget {
  ByteCareMobile() {
    AuthStorage.init();
    ByteCareApi.init(apiHostUri);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AccountController()),
        ChangeNotifierProvider(create: (context) {
          return HospitalMarkerController.withUser(
            userMarker: Marker(
              markerId: MarkerId(''),
              infoWindow: InfoWindow(title: 'You', snippet: 'Your location'),
            ),
          );
        }),
      ],
      child: MaterialApp(
        initialRoute: SplashScreen.id,
        routes: {
          SplashScreen.id: (context) => SplashScreen(),
          LandingScreen.id: (context) => LandingScreen(),
          RegistrationScreen.id: (context) => RegistrationScreen(),
          LoginScreen.id: (context) => LoginScreen(),
          ForgotPasswordScreen.id: (context) => ForgotPasswordScreen(),
          ApplicationScreen.id: (context) => ApplicationScreen(),
          BookAppointmentScreen.id: (context) => BookAppointmentScreen(),
          CreatePatientScreen.id: (context) => CreatePatientScreen(),
        },
      ),
    );
  }
}
