import 'package:bytecare_mobile/constants/theme.dart';
import 'package:flutter/material.dart';

/* Project-level Imports */
// Data Models
import '../models/gradient_color.dart';
import '../models/gradient_border_side.dart';

Path buildCurvePath(
  Size size, {
  double archHeight,
  Offset shift = Offset.zero,
  bool close = false,
}) {
  var sw = size.width;
  var sh = size.height;

  var ov = shift.dy;
  var oh = shift.dx;

  Path path = Path();

  // path.quadraticBezierTo(sw / 2 + oh, ov, sw + oh, sh / 2 + ov);
  if (archHeight > 0) {
    path.moveTo(oh, archHeight + ov);
    path.quadraticBezierTo(
        sw / 2 + oh, ov - archHeight, sw + oh, archHeight + ov);
  } else if (archHeight < 0) {
    path.moveTo(oh, ov);
    path.quadraticBezierTo(sw / 2 + oh, ov - archHeight * 2, sw + oh, ov);
  } else {
    path.moveTo(oh, archHeight + ov);
    path.lineTo(sw, 0);
  }

  if (close) {
    path.lineTo(sw, sh);
    path.lineTo(0, sh);
    path.close();
  }

  return path;
}

class BottomAppbarItem {
  final void Function(Widget) onPressed;
  final Widget page;
  final IconData icon;
  final String label;
  final bool isCurrent;

  BottomAppbarItem(
      {@required this.onPressed,
      @required this.icon,
      this.page,
      this.label,
      this.isCurrent});
}

class ArchedBottomAppbar extends StatelessWidget {
  final List<BottomAppbarItem> items;
  final double apparentHeight = 64.0;
  final double archHeight = -32.0;
  final Color currentItemColor;

  ArchedBottomAppbar({
    @required this.items,
    @required this.currentItemColor,
  }) : assert(items != null);

  @override
  Widget build(BuildContext context) {
    var itemsRow = Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: items.map((e) {
        return Expanded(
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: () => e.onPressed(e.page),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  height: apparentHeight, // Basically the body size.
                  child: Center(
                    child: Icon(
                      e.icon,
                      color: e.isCurrent ? currentItemColor : Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );

    return SizedOverflowBox(
      size: Size.fromHeight(apparentHeight),
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        height: apparentHeight + archHeight.abs(),
        child: CustomPaint(
          painter: ArchedNavbarCustomPainter(
            archHeight: archHeight,
            fill: GradientColor(Colors.white),
            borderSide: GradientBorderSide(
              borderFill: GradientColor(kThemePrimaryAngledLinearGradient),
              width: 2.0,
            ),
          ),
          child: ClipPath(
            clipper: ArchedNavbarCustomClipper(
              borderWidth: 2.0,
              archHeight: archHeight,
            ),
            child: itemsRow,
          ),
        ),
      ),
    );
  }
}

class ArchedNavbarCustomPainter extends CustomPainter {
  final GradientBorderSide borderSide;
  final GradientColor fill;
  final double archHeight;

  ArchedNavbarCustomPainter({
    @required this.fill,
    @required this.archHeight,
    GradientBorderSide borderSide,
  }) : this.borderSide = borderSide ?? GradientBorderSide.zero;

  @override
  void paint(Canvas canvas, Size size) {
    Rect bodyRect = Rect.fromLTWH(0, 0, size.width, size.height);
    Path backgroundPath = buildCurvePath(
      size,
      archHeight: archHeight,
      close: true,
    );
    Path borderPath = buildCurvePath(
      size,
      archHeight: archHeight,
      shift: Offset(0, borderSide.width / 2),
    );

    canvas.drawShadow(
      backgroundPath.shift(Offset(0, -5)),
      Colors.black,
      2.0,
      true,
    );

    if (fill.fillAsColor != Colors.transparent) {
      Paint bgPaint = Paint();
      bgPaint.style = PaintingStyle.fill;

      if (fill.isGradient) {
        Gradient g = fill.fillValue;
        bgPaint.shader = g.createShader(bodyRect);
      } else {
        Color g = fill.fillValue;
        bgPaint.color = g;
      }

      canvas.drawPath(backgroundPath, bgPaint);
    }

    Paint brdrPaint = Paint();
    brdrPaint.style = PaintingStyle.stroke;
    brdrPaint.strokeWidth = borderSide.width;

    if (borderSide.borderFill.isGradient) {
      Gradient g = borderSide.borderFill.fillValue;
      brdrPaint.shader = g.createShader(bodyRect);
    } else {
      Color g = borderSide.borderFill.fillValue;
      brdrPaint.color = g;
    }

    canvas.drawPath(borderPath, brdrPaint);
  }

  // TODO: Add actual check.
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class ArchedNavbarCustomClipper extends CustomClipper<Path> {
  final double borderWidth;
  final double archHeight;

  ArchedNavbarCustomClipper({
    this.borderWidth,
    this.archHeight,
  });

  @override
  Path getClip(Size size) {
    return buildCurvePath(
      size,
      archHeight: archHeight,
      close: true,
    );
  }

  // TODO: Add actual check.
  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
