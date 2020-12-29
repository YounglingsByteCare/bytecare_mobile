import 'package:flutter/material.dart';

class RaisedGradientButton extends StatelessWidget {
  final Gradient backgroundGradient;
  final BorderRadius borderRadius;
  final Function onPressed;
  final Color textColor;
  final EdgeInsets padding;
  final Widget child;

  RaisedGradientButton({
    @required this.backgroundGradient,
    @required this.onPressed,
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
          gradient: backgroundGradient,
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
