import 'package:flutter/material.dart';

import './colors.dart';
import '../utils/color.dart';

// Theme Gradients
final LinearGradient kThemeGradientPrimary = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: <Color>[
    kThemeColorPrimary,
    kThemeColorSecondary,
  ],
  stops: [0.0, 1.0],
);
final LinearGradient kThemeGradientPrimaryAngled = LinearGradient(
  begin: Alignment.topRight,
  end: Alignment.bottomLeft,
  colors: <Color>[
    kThemeColorPrimary,
    kThemeColorSecondary,
  ],
  stops: [0.0, 1.0],
);
final LinearGradient kThemeGradientPrimaryHorizontal = LinearGradient(
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
  colors: <Color>[
    kThemeColorPrimary,
    kThemeColorSecondary,
  ],
  stops: [0.0, 1.0],
);
final LinearGradient kThemeGradientPrimaryLight = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: <Color>[
    brighten(kThemeColorPrimary, 90),
    brighten(kThemeColorSecondary, 90),
  ],
  stops: [0.0, 1.0],
);

// Button Gradients
final LinearGradient kButtonBackgroundLinearGradient = LinearGradient(
  begin: Alignment.bottomLeft,
  end: Alignment.topRight,
  colors: <Color>[
    kThemeColorPrimary,
    kThemeColorSecondary,
  ],
  stops: [0.0, 1.0],
);
final LinearGradient kButtonBackgroundLightLinearGradient = LinearGradient(
  begin: Alignment.bottomLeft,
  end: Alignment.topRight,
  colors: <Color>[
    brighten(kThemeColorPrimary, 90),
    brighten(kThemeColorSecondary, 90),
  ],
  stops: [0.0, 1.0],
);
