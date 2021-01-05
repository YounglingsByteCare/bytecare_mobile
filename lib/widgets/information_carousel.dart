import 'package:flutter/material.dart';
import 'package:ms_undraw/ms_undraw.dart';

TextStyle _defaultTitleTextStyle = TextStyle(
  fontSize: 16.0,
  color: Colors.black,
);
TextStyle _defaultSubtitleTextStyle = TextStyle(
  fontSize: 12.0,
  color: Colors.black,
);

class InformationCarousel extends StatefulWidget {
  final BoxShadow carouselShadow;
  final TextStyle titleStyle;
  final TextStyle subtitleStyle;
  final Color primaryColor;
  final Color backgroundColor;

  InformationCarousel({
    this.carouselShadow,
    this.titleStyle,
    this.subtitleStyle,
    this.primaryColor,
    this.backgroundColor,
  });

  @override
  _InformationCarouselState createState() => _InformationCarouselState();
}

class _InformationCarouselState extends State<InformationCarousel> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: widget.backgroundColor ?? Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: <BoxShadow>[widget.carouselShadow],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              AspectRatio(
                aspectRatio: 10 / 9,
                child: UnDraw(
                  color: widget.primaryColor,
                  illustration: UnDrawIllustration.security,
                ),
              ),
              Divider(
                height: 1.0,
                indent: 64.0,
                endIndent: 64.0,
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                margin: EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    3,
                    (index) => Container(
                      width: 8.0,
                      height: 8.0,
                      margin: EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                        color: widget.primaryColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20.0),
        Text(
          'Safety',
          style: _defaultTitleTextStyle.merge(widget.titleStyle),
        ),
        SizedBox(height: 4.0),
        Text(
          'We work hard to ensure that our application '
          'incorporates top security measures to protect your data.',
          textAlign: TextAlign.center,
          style: _defaultSubtitleTextStyle.merge(widget.subtitleStyle),
        ),
      ],
    );
  }
}
