import 'package:flutter/material.dart';

/* Project-level Imports */
import '../models/gradient_color.dart';

class GradientButton extends StatelessWidget {
  final void Function() onPressed;
  final Widget child;
  final GradientColorModel background;
  final BorderRadius borderRadius;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final BoxShape shape;
  final String heroTag;
  final double radius;

  GradientButton({
    @required this.child,
    @required this.onPressed,
    this.borderRadius,
    this.heroTag,
    this.padding,
    this.margin,
    this.radius,
    this.shape,
    GradientColorModel background,
  })  : assert(padding == null || padding.isNonNegative),
        assert(margin == null || margin.isNonNegative),
        assert(shape == BoxShape.circle ? borderRadius == null : true),
        this.background = background ?? GradientColorModel(Colors.white);

  @override
  Widget build(BuildContext context) {
    return shape == BoxShape.circle
        ? _buildCircularShape()
        : _buildRectangularShape();
  }

  Widget _buildCircularShape() {
    Widget current = Center(child: child);

    current = SizedBox(
      width: radius * 2,
      height: radius * 2,
      child: current,
    );

    if (padding != null) {
      current = Padding(padding: padding, child: current);
    }

    current = DecoratedBox(
      decoration: BoxDecoration(
        gradient: background.fillAsGrad,
        color: background.fillAsColor,
        shape: BoxShape.circle,
      ),
      child: current,
    );

    current = ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: Colors.transparent,
        shape: CircleBorder(),
        padding: EdgeInsets.zero,
        shadowColor: Colors.black54,
      ),
      child: current,
    );

    if (margin != null) {
      current = Padding(padding: margin, child: current);
    }

    if (heroTag != null) {
      current = Hero(tag: heroTag, child: current);
    }

    return current;
  }

  Widget _buildRectangularShape() {
    Widget current = Center(child: child);

    if (padding != null) {
      current = Padding(padding: padding, child: current);
    }

    current = DecoratedBox(
      decoration: BoxDecoration(
        gradient: background.fillAsGrad,
        color: background.fillAsColor,
        borderRadius: borderRadius,
      ),
      child: current,
    );

    current = ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: borderRadius),
        padding: EdgeInsets.zero,
        shadowColor: Colors.black54,
      ),
      child: current,
    );

    if (margin != null) {
      current = Padding(padding: margin, child: current);
    }

    if (heroTag != null) {
      current = Hero(tag: heroTag, child: current);
    }

    return current;
  }
}
