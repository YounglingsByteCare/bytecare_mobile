import 'package:flutter/material.dart';

import '../constants/theme.dart';

class OutlineGradientButton extends StatelessWidget {
  final BorderSide borderSide;
  final Gradient borderGradient;
  final BorderRadius borderRadius;
  final Color backgroundColor;
  final Function onPressed;
  final Color textColor;
  final EdgeInsets padding;
  final Widget child;

  OutlineGradientButton({
    @required this.borderGradient,
    @required this.onPressed,
    this.backgroundColor,
    this.borderSide,
    this.textColor,
    this.padding,
    this.borderRadius,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: onPressed,
      textColor: textColor,
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      clipBehavior: Clip.hardEdge,
      padding: EdgeInsets.all(0.0),
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: borderRadius,
        ),
        child: Container(
          constraints: BoxConstraints(
            minWidth: 88.0,
            minHeight: 36.0,
          ),
          alignment: Alignment.center,
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}

class _GradientPainter extends CustomPainter {
  final Paint _paint = Paint();
  final double radius;
  final double strokeWidth;
  final Gradient gradient;

  _GradientPainter(
      {@required double strokeWidth,
      @required double radius,
      @required Gradient gradient})
      : this.strokeWidth = strokeWidth,
        this.radius = radius,
        this.gradient = gradient;

  @override
  void paint(Canvas canvas, Size size) {
    // create outer rectangle equals size
    Rect outerRect = Offset.zero & size;
    var outerRRect =
        RRect.fromRectAndRadius(outerRect, Radius.circular(radius));

    // create inner rectangle smaller by strokeWidth
    Rect innerRect = Rect.fromLTWH(strokeWidth, strokeWidth,
        size.width - strokeWidth * 2, size.height - strokeWidth * 2);
    var innerRRect = RRect.fromRectAndRadius(
        innerRect, Radius.circular(radius - strokeWidth));

    // apply gradient shader
    _paint.shader = gradient.createShader(outerRect);

    // create difference between outer and inner paths and draw it
    Path path1 = Path()..addRRect(outerRRect);
    Path path2 = Path()..addRRect(innerRRect);
    var path = Path.combine(PathOperation.difference, path1, path2);
    canvas.drawPath(path, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => oldDelegate != this;
}
