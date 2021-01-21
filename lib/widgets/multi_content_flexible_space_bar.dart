import 'dart:math';

import 'package:flutter/material.dart';

class MultiContentFlexibleSpaceBar extends StatelessWidget {
  final Widget collapsedTitle;
  final Widget expandedTitle;
  final Image backgroundImage;

  const MultiContentFlexibleSpaceBar({
    Key key,
    @required this.collapsedTitle,
    this.expandedTitle,
    this.backgroundImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      final settings = context
          .dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>();
      final deltaExtent = settings.maxExtent - settings.minExtent;
      final t =
          (1.0 - (settings.currentExtent - settings.minExtent) / deltaExtent)
              .clamp(0.0, 1.0) as double;
      final fadeStart = max(0.0, 1.0 - kToolbarHeight / deltaExtent);
      const fadeEnd = 0.0;
      final opacity = 1.0 - Interval(fadeStart, fadeEnd).transform(t);

      return Stack(
        children: [
          Center(
            child: Opacity(
              opacity: 1 - opacity,
              child: collapsedTitle,
            ),
          ),
          Opacity(
            opacity: opacity,
            child: Stack(
              children: [
                getBackgroundImage(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: expandedTitle,
                ),
              ],
            ),
          ),
        ],
      );
    });
  }

  Widget getBackgroundImage() {
    return Container(
      width: double.infinity,
      child: backgroundImage,
    );
  }
}
