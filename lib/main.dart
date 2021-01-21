import 'package:bytecare_mobile/screens/book_appointment_screen.dart';
import 'package:bytecare_mobile/screens/errors/denied_location_permission.dart';
import 'package:bytecare_mobile/screens/forgotpassword_screen.dart';
import 'package:flutter/material.dart';

/* Project-level Imports */
// Services
import 'services/bytecare_api.dart';
import 'services/storage_manager.dart';

// Screens
import 'screens/application_screen.dart';
import 'screens/forgotpassword_screen.dart';
import 'screens/book_appointment_screen.dart';
import 'screens/landing_screen.dart';
import 'screens/login_screen.dart';
import 'screens/registration_screen.dart';
import 'screens/splash_screen.dart';

void main() {
  // Gonna need to change this when debugging, cause of different IPs.
  var apiHostUri = Uri(
    scheme: 'http',
    host: '10.0.0.110',
    port: 5000,
  );
  ByteCareAPI(apiHostUri);

  runApp(ByteCareMobile());
}

class ByteCareMobile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id: (context) => SplashScreen(),
        LandingScreen.id: (context) => LandingScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        ForgotPasswordScreen.id: (context) => ForgotPasswordScreen(),
        ApplicationScreen.id: (context) => ApplicationScreen(),
        DeniedLocationPermissionErrorScreen.id: (context) {
          return DeniedLocationPermissionErrorScreen();
        },
        BookAppointmentScreen.id: (context) => BookAppointmentScreen(),
      },
    );
  }
}
