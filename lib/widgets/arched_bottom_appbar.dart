import 'package:bytecare_mobile/theme/gradients.dart';
import 'package:flutter/material.dart';

/* Project-level Imports */
// Data Models
import '../models/gradient_border_side.dart';
import '../models/gradient_color.dart';

// Interfaces
import '../interfaces/application_page.dart';

Path buildCurvePath(
  Size size, {
  double archHeight,
  Offset shift = Offset.zero,
  bool close = false,
}) {
  var sw = size.width;
  var sh = size.height;

  var oh = shift.dx;
  var ov = shift.dy;

  Path p = Path();

  if (archHeight > 0) {
    p.moveTo(oh, archHeight + ov);
    p.quadraticBezierTo(sw / 2 + oh, ov - archHeight, sw + oh, archHeight + ov);
  } else if (archHeight < 0) {
    p.moveTo(oh, ov);
    p.quadraticBezierTo(sw / 2 + oh, ov - archHeight * 2, sw + oh, ov);
  } else {
    p.moveTo(oh, archHeight + ov);
    p.lineTo(sw, 0);
  }

  if (close) {
    p.lineTo(sw, sh);
    p.lineTo(0, sh);
    p.close();
  }

  return p;
}

class BottomAppbarItem {
  final void Function(BuildContext, Widget, int) onPressed;
  final ApplicationPage page;
  final IconData icon;
  final String label;
  bool _isActive;

  BottomAppbarItem({
    @required this.onPressed,
    @required this.icon,
    this.page,
    this.label,
    bool active = false,
  }) : _isActive = active;

  get isActive => _isActive;

  set isActive(val) => _isActive = val;
}

class ArchedBottomAppbar extends StatelessWidget {
  final List<BottomAppbarItem> items;
  final BuildContext context;
  final double bodyHeight;
  final double archHeight;
  final Color currentItemColor;

  ArchedBottomAppbar({
    @required this.items,
    @required this.currentItemColor,
    this.context,
    this.bodyHeight = 64.0,
    this.archHeight = -32.0,
  })  : assert(items != null),
        assert(items.length > 2),
        assert(bodyHeight > 0);

  @override
  Widget build(BuildContext context) {
    return SizedOverflowBox(
      size: Size.fromHeight(bodyHeight),
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        height: bodyHeight + archHeight.abs(),
        child: CustomPaint(
          painter: ArchedBottomAppbarPainter(
            archHeight: archHeight,
            fill: GradientColorModel(Colors.white),
            borderSide: GradientBorderSide(
              borderFill: GradientColorModel(kThemeGradientPrimaryAngled),
              width: 2.0,
            ),
          ),
          child: ClipPath(
            clipper: ArchedBottomAppbarClipper(
                borderWidth: 2.0, archHeight: archHeight),
            child: _buildItemsRow(items),
          ),
        ),
      ),
    );
  }

  Widget _buildItemsRow(List<BottomAppbarItem> item) {
    List<Widget> itemsRow = [];

    for (var e in items) {
      Widget current = Align(
        alignment: Alignment.bottomCenter,
        child: SizedBox(
          height: bodyHeight,
          child: Center(
            child: Icon(
              e.icon,
              color: e.isActive ? currentItemColor : Colors.black,
            ),
          ),
        ),
      );

      current = Expanded(
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: () =>
                e.onPressed(this.context, e.page.asWidget(), items.indexOf(e)),
            child: current,
          ),
        ),
      );

      itemsRow.add(current);
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: itemsRow,
    );
  }
}

class ArchedBottomAppbarPainter extends CustomPainter {
  final GradientBorderSide borderSide;
  final GradientColorModel fill;
  final double archHeight;

  ArchedBottomAppbarPainter({
    @required this.fill,
    @required this.archHeight,
    GradientBorderSide borderSide,
  }) : this.borderSide = borderSide ?? GradientBorderSide.zero;

  @override
  void paint(Canvas canvas, Size size) {
    Rect bodyRect = Rect.fromLTWH(0, 0, size.width, size.height);
    Path bgpath = buildCurvePath(
      size,
      archHeight: archHeight,
      close: true,
    );
    Path bdrpath = buildCurvePath(
      size,
      archHeight: archHeight,
      shift: Offset(0, borderSide.width / 2),
    );

    canvas.drawShadow(bgpath.shift(Offset(0, -5)), Colors.black, 2.0, true);

    if (fill.fillValue != Colors.transparent) {
      Paint bgpaint = Paint();
      bgpaint.style = PaintingStyle.fill;

      if (fill.isGradient) {
        Gradient g = fill.fillValue;
        bgpaint.shader = g.createShader(bodyRect);
      } else {
        Color c = fill.fillValue;
        bgpaint.color = c;
      }

      canvas.drawPath(bgpath, bgpaint);
    }

    if (borderSide.isVisible) {
      Paint bdrpaint = Paint();
      bdrpaint.style = PaintingStyle.stroke;
      bdrpaint.strokeWidth = borderSide.width;

      if (borderSide.borderFill.isGradient) {
        Gradient g = borderSide.borderFill.fillValue;
        bdrpaint.shader = g.createShader(bodyRect);
      } else {
        Color c = borderSide.borderFill.fillValue;
        bdrpaint.color = c;
      }

      canvas.drawPath(bdrpath, bdrpaint);
    }
  }

  bool shouldRepaint(covariant ArchedBottomAppbarPainter oldDelegate) {
    return oldDelegate.borderSide != borderSide ||
        oldDelegate.fill != fill ||
        oldDelegate.archHeight != archHeight;
  }
}

class ArchedBottomAppbarClipper extends CustomClipper<Path> {
  final double borderWidth;
  final double archHeight;

  ArchedBottomAppbarClipper({this.borderWidth, this.archHeight});

  @override
  Path getClip(Size size) {
    return buildCurvePath(size, archHeight: archHeight, close: true);
  }

  @override
  bool shouldReclip(covariant ArchedBottomAppbarClipper oldClipper) {
    return oldClipper.borderWidth != borderWidth ||
        oldClipper.archHeight != archHeight;
  }
}
