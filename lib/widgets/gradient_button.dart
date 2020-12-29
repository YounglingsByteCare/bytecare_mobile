import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  final CustomPainter _painter;
  final Function onPressed;
  final Widget child;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final BorderRadius borderRadius;
  final GradientBorderSide borderSide;

  GradientButton({
    @required GradientColor backgroundFill,
    @required this.onPressed,
    GradientBorderSide borderSide,
    this.padding = EdgeInsets.zero,
    this.margin = EdgeInsets.zero,
    double elevation = 1.0,
    Color shadowColor = Colors.black,
    BorderRadius borderRadius,
    this.child,
  })  : borderRadius = borderRadius ?? BorderRadius.circular(4.0),
        borderSide = borderSide ?? GradientBorderSide.zero,
        _painter = _GradientButtonPainter(
          bgFill: backgroundFill,
          borderRadius: borderRadius,
          borderSide: borderSide,
          elevation: elevation >= 0 ? elevation : 0.0,
          shadowColor: shadowColor,
        );

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _painter,
      child: Material(
        type: MaterialType.transparency,
        borderRadius: borderRadius,
        child: InkWell(
          onTap: onPressed,
          child: Container(
            color: Colors.transparent,
            padding: padding,
            child: Center(child: child),
          ),
        ),
      ),
    );
  }
}

class GradientColor {
  final dynamic fillValue;
  final bool _isGradient;

  const GradientColor(this.fillValue)
      : assert(fillValue is Gradient || fillValue is Color),
        _isGradient = fillValue is Gradient;

  bool get isGradient => _isGradient;
}

class GradientBorderSide {
  final GradientColor borderFill;
  final double width;

  static GradientBorderSide zero = GradientBorderSide(
    borderFill: GradientColor(Colors.transparent),
    width: 0,
  );

  GradientBorderSide({
    @required this.borderFill,
    this.width = 1.0,
  });

  bool get isGradientBorder => borderFill.isGradient;
}

class _GradientButtonPainter extends CustomPainter {
  final BorderRadius borderRadius;
  final GradientBorderSide borderSide;
  final Color shadowColor;
  final double elevation;
  final GradientColor bgFill;

  _GradientButtonPainter({
    @required this.borderSide,
    @required this.bgFill,
    BorderRadius borderRadius,
    this.shadowColor = Colors.black,
    this.elevation = 1.0,
  })  : assert(elevation > 0 ? shadowColor != null : true),
        this.borderRadius = borderRadius ?? BorderRadius.circular(0);

  @override
  void paint(Canvas canvas, Size size) {
    Rect outerRect = Offset.zero & size;
    RRect outerRRect = borderRadius.toRRect(outerRect);

    Rect innerRect = Rect.fromLTWH(
      borderSide.width,
      borderSide.width,
      size.width - borderSide.width * 2,
      size.height - borderSide.width * 2,
    );
    RRect innerRRect = borderRadius
        .subtract(BorderRadius.circular(borderSide.width))
        .resolve(TextDirection.ltr)
        .toRRect(innerRect);

    if (elevation >= 0) {
      Path shadowPath = Path();
      shadowPath.addRRect(outerRRect);
      canvas.drawShadow(shadowPath, shadowColor, elevation, false);
    }

    if (borderSide.width > 0) {
      Paint borderPaint = Paint();
      borderPaint.style = PaintingStyle.fill;
      Path borderRect;
      if (borderSide.isGradientBorder) {
        Gradient g = borderSide.borderFill.fillValue;
        borderPaint.shader = g.createShader(outerRect);

        borderRect = Path()..addRRect(outerRRect);
      } else {
        Color g = borderSide.borderFill.fillValue;
        borderPaint.color = g;

        borderRect = Path()..addRRect(outerRRect);
      }

      // canvas.drawPath(borderRect, borderPaint);
      canvas.drawDRRect(outerRRect, innerRRect, borderPaint);
    }

    Paint bgPaint = Paint();
    bgPaint.style = PaintingStyle.fill;
    Path bgRect;
    if (bgFill.isGradient) {
      Gradient g = bgFill.fillValue;
      bgPaint.shader = g.createShader(innerRect);

      bgRect = Path()..addRRect(innerRRect);
    } else {
      Color g = bgFill.fillValue;
      bgPaint.color = g;

      bgRect = Path()..addRRect(innerRRect);
    }
    canvas.drawPath(bgRect, bgPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => oldDelegate != this;
}
