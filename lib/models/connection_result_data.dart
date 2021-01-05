import 'package:flutter/material.dart';

// ProcessingResultThemeData
class ConnectionResultData {
  final Widget icon;
  final String message;
  final Color color;
  final Color waveColor;

  ConnectionResultData({
    this.icon,
    this.color,
    this.waveColor,
    this.message,
  });

  bool get hasIcon => icon != null;
}
