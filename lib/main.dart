import 'package:flutter/material.dart';

/* Project-level Imports */
// Services
import 'services/bytecare_api.dart';

// Screens
import 'screens/welcome_screen.dart';
import 'screens/login_screen.dart';
import 'screens/registration_screen.dart';

void main() {
  // Gonna need to change this when debugging, cause of different IPs.
  Uri apiHostUri = Uri(
    scheme: 'https',
    host: '127.0.0.1',
    port: 5000,
  );

  ByteCareAPI.initInstance(apiHostUri);
  runApp(ByteCareMobile());
}

class ByteCareMobile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: Check is user is already logged in, then skip to content screen.

    return MaterialApp(
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
      },
    );
  }
}
