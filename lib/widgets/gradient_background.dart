import 'package:flutter/material.dart';

/* Project-level Imports */
// Data Models
import '../models/gradient_color.dart';

class GradientBackground extends StatelessWidget {
  final ThemeData theme;
  final GradientColorModel background;
  final Widget child;
  final bool ignoreSafeArea;

  GradientBackground({
    @required this.background,
    this.theme,
    this.child,
    this.ignoreSafeArea,
  });

  @override
  Widget build(BuildContext context) {
    Widget current = child;

    if (!ignoreSafeArea) {
      current = SafeArea(child: current);
    }

    current = Container(
      decoration: BoxDecoration(
        gradient: background.fillAsGrad,
        color: background.fillAsColor,
      ),
      child: current,
    );

    if (theme != null) {
      current = Theme(data: theme, child: current);
    }

    return current;
  }
}
