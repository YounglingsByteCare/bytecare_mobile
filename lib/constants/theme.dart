import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../utils/color.dart';

final Color kThemePrimaryBlue = Color(0xFF1D9FCF);
final Color kThemePrimaryPurple = Color(0xFF940094);
final Color kThemeSuccessColor = Color(0xFF30B400);
final Color kThemeErrorColor = Colors.red;

final double kDefaultMapZoom = 15.0;
final CameraPosition kDefaultCameraPosition = CameraPosition(
  target: LatLng(-33.92006831792547, 18.41443031685197),
  zoom: kDefaultMapZoom,
);

//#region Global Gradients
final LinearGradient kThemePrimaryLinearGradient = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: <Color>[
    kThemePrimaryBlue,
    kThemePrimaryPurple,
  ],
  stops: [0.0, 1.0],
);
final LinearGradient kThemePrimaryAngledLinearGradient = LinearGradient(
  begin: Alignment.topRight,
  end: Alignment.bottomLeft,
  colors: <Color>[
    kThemePrimaryBlue,
    kThemePrimaryPurple,
  ],
  stops: [0.0, 1.0],
);
final LinearGradient kThemePrimaryLightLinearGradient = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: <Color>[
    brighten(kThemePrimaryBlue, 90),
    brighten(kThemePrimaryPurple, 90),
  ],
  stops: [0.0, 1.0],
);
//#endregion

final ThemeData kByteCareThemeData = ThemeData.light().copyWith(
  appBarTheme: kClearAppBarTheme,
  primaryColor: kThemePrimaryBlue,
);

// This is the AppBarTheme for the 'clear' AppBar.
final AppBarTheme kClearAppBarTheme = AppBarTheme(
  elevation: 0.0,
  color: Colors.transparent,
  textTheme: TextTheme(
    headline6: kTitle1TextStyle,
  ),
);

final TextStyle kTitle1TextStyle = GoogleFonts.montserrat(
  color: Colors.black,
  fontWeight: FontWeight.bold,
  fontSize: 32.0,
);

final TextStyle kTitle2TextStyle = GoogleFonts.montserrat(
  color: Colors.black,
  fontWeight: FontWeight.bold,
  fontSize: 24.0,
);

final TextStyle kSubtitleTextStyle = GoogleFonts.montserrat(
  color: Colors.grey.shade700,
  fontSize: 24.0,
);

final TextStyle kSubtitle1TextStyle = GoogleFonts.montserrat(
  color: Colors.grey.shade700,
  fontSize: 24.0,
);

final TextStyle kSubtitle2TextStyle = GoogleFonts.montserrat(
  color: Colors.grey.shade700,
  fontSize: 16.0,
);

final TextStyle kBody1TextStyle = GoogleFonts.openSans(
  color: Colors.black,
  fontSize: 16.0,
);

final TextStyle kBody2TextStyle = GoogleFonts.openSans(
  color: Colors.black,
  fontSize: 12.0,
);

/*
 * Button Styles
 */
final LinearGradient kButtonBackgroundLinearGradient = LinearGradient(
  begin: Alignment.bottomLeft,
  end: Alignment.topRight,
  colors: <Color>[
    kThemePrimaryPurple,
    kThemePrimaryBlue,
  ],
  stops: [0.0, 1.0],
);
final LinearGradient kButtonBackgroundLightLinearGradient = LinearGradient(
  begin: Alignment.bottomLeft,
  end: Alignment.topRight,
  colors: <Color>[
    brighten(kThemePrimaryBlue, 90),
    brighten(kThemePrimaryPurple, 90),
  ],
  stops: [0.0, 1.0],
);

final TextStyle kButtonBody1TextStyle = GoogleFonts.montserrat(
  fontSize: 16.0,
);
final TextStyle kButtonBody2TextStyle = GoogleFonts.openSans(
  fontSize: 12.0,
);

/*
 * Input Data
 */
// Input Decoration for Form Fields, not sure about others, yet.
final double kFormFieldSpacing = 20.0;
const double kTextInputFieldElevation = 4.0;

final kFormFieldInputDecoration = InputDecoration(
  filled: true,
  fillColor: Colors.white,
  contentPadding: EdgeInsets.symmetric(
    vertical: 16.0,
    horizontal: 20.0,
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.grey.shade300,
      width: 1.0,
    ),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: kThemePrimaryBlue,
      width: 1.0,
    ),
  ),
  errorBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: kThemeErrorColor,
      width: 1.0,
    ),
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: kThemeErrorColor,
      width: 2.0,
    ),
  ),
);


final Duration kProcessDelayDuration = Duration(milliseconds: 350);