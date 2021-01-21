import 'package:flutter/material.dart';

/* Project-level Imports */
import '../models/gradient_color.dart';

class GradientButton extends StatelessWidget {
  final void Function() onPressed;
  final Widget child;

  final GradientColor backgroundFill;
  final BorderRadius borderRadius;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final BoxShape shape;
  final double radius;

  GradientButton({
    @required this.child,
    @required this.onPressed,
    this.borderRadius,
    this.padding,
    this.margin,
    this.radius,
    this.shape,
    GradientColor backgroundFill,
  })  : assert(padding == null || padding.isNonNegative),
        assert(margin == null || margin.isNonNegative),
        assert(shape == BoxShape.circle ? radius != null : true),
        this.backgroundFill = backgroundFill ?? GradientColor(Colors.white);

  @override
  Widget build(BuildContext context) {
    return shape == BoxShape.circle
        ? _buildCircularShape()
        : _buildRectangularShape();
  }

  Widget _buildRectangularShape() {
    Widget current = Center(child: child);

    if (padding != null) {
      current = Padding(
        padding: padding,
        child: current,
      );
    }

    current = DecoratedBox(
      decoration: BoxDecoration(
        gradient: backgroundFill.fillAsGrad,
        color: backgroundFill.fillAsColor,
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

    return current;
  }

  Widget _buildCircularShape() {
    Widget current = Center(child: child);

    if (padding != null) {
      current = Padding(
        padding: padding,
        child: current,
      );
    }

    current = RawMaterialButton(
      onPressed: onPressed,
      shape: CircleBorder(),
      child: current,
    );

    current = DecoratedBox(
      decoration: BoxDecoration(
        gradient: backgroundFill.fillAsGrad,
        color: backgroundFill.fillAsColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 1),
            blurRadius: 3.0,
            color: Colors.black26,
          ),
        ],
      ),
      child: current,
    );

    current = SizedBox(
      width: radius * 2,
      height: radius * 2,
      child: current,
    );

    // current = DecoratedBox(
    //   decoration: BoxDecoration(
    //     gradient: backgroundFill.fillAsGrad,
    //     color: backgroundFill.fillAsColor,
    //     shape: BoxShape.circle,
    //   ),
    //   child: Padding(
    //     padding: padding,
    //     child: current,
    //   ),
    // );

    // current = SizedBox(
    //   width: radius * 2,
    //   height: radius * 2,
    //   child: RawMaterialButton(
    //     onPressed: onPressed,
    //     constraints: BoxConstraints(),
    //     shape: CircleBorder(),
    //     elevation: 5.0,
    //     child: current,
    //   ),
    // );

    if (margin != null) {
      current = Padding(
        padding: margin,
        child: current,
      );
    }

    return current;
  }
}
