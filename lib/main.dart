import 'package:flutter/material.dart';

/* Project-level Imports */
// Services
import 'services/bytecare_api.dart';

// Screens
import 'screens/landing_screen.dart';
import 'screens/login_screen.dart';
import 'screens/registration_screen.dart';
import 'screens/application_screen.dart';

void main() {
  // Gonna need to change this when debugging, cause of different IPs.
  var apiHostUri = Uri(
    scheme: 'https',
    host: 'byteme-test.herokuapp.com',
  );

  ByteCareAPI(apiHostUri);

  runApp(ByteCareMobile());
}

class ByteCareMobile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: Check is user is already logged in, then skip to content screen.
    String initialRoute;
    if (true) {
      initialRoute = ApplicationScreen.id;
    }
    initialRoute = LandingScreen.id;

    return MaterialApp(
      initialRoute: initialRoute,
      routes: {
        LandingScreen.id: (context) => LandingScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        ApplicationScreen.id: (context) => ApplicationScreen(),
      },
    );
  }
}
