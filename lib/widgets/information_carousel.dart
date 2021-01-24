import 'package:flutter/material.dart';
import 'package:ms_undraw/ms_undraw.dart';
import 'package:carousel_slider/carousel_slider.dart';

TextStyle _defaultTitleTextStyle = TextStyle(
  fontSize: 16.0,
  color: Colors.black,
);
TextStyle _defaultSubtitleTextStyle = TextStyle(
  fontSize: 10.0,
  color: Colors.black,
);

class InformationCarouselItem {
  final UnDrawIllustration illustration;
  final String title;
  final String description;

  InformationCarouselItem({this.illustration, this.title, this.description});
}

class InformationCarousel extends StatefulWidget {
  final List<InformationCarouselItem> items;
  final BoxShadow carouselShadow;
  final TextStyle titleStyle;
  final TextStyle subtitleStyle;
  final Color primaryColor;
  final Color backgroundColor;

  InformationCarousel({
    @required this.items,
    @required this.primaryColor,
    this.carouselShadow,
    this.titleStyle,
    this.subtitleStyle,
    this.backgroundColor,
  })  : assert(items != null),
        assert(items.length > 0);

  @override
  _InformationCarouselState createState() => _InformationCarouselState();
}

class _InformationCarouselState extends State<InformationCarousel> {
  int _visibleIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.items.length == 1) {
      return _buildItem(widget.items[0]);
    } else {
      return Column(
        children: [
          CarouselSlider(
            items: widget.items.map((e) => _buildItem(e)).toList(),
            options: CarouselOptions(
              height: 400.0,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 20),
              enableInfiniteScroll: true,
              enlargeCenterPage: true,
              onPageChanged: (index, reason) {
                setState(() => _visibleIndex = index);
              },
            ),
          ),
          SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.items.map(
              (e) {
                return Container(
                  width: 16.0,
                  height: 16.0,
                  margin: EdgeInsets.symmetric(horizontal: 4.0),
                  decoration: BoxDecoration(
                    color: widget.items.indexOf(e) == _visibleIndex
                        ? Colors.white
                        : widget.primaryColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: widget.primaryColor, width: 2.0),
                    boxShadow: widget.carouselShadow != null
                        ? [widget.carouselShadow]
                        : [],
                  ),
                );
              },
            ).toList(),
          ),
        ],
      );
    }
  }

  Widget _buildItem(InformationCarouselItem item) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Flexible(
            child: AspectRatio(
              aspectRatio: 10 / 9,
              child: UnDraw(
                color: widget.primaryColor,
                illustration: item.illustration,
              ),
            ),
          ),
          SizedBox(height: 16.0),
          Text(
            item.title,
            style: _defaultTitleTextStyle.merge(widget.titleStyle),
          ),
          Text(
            item.description,
            style: _defaultSubtitleTextStyle.merge(widget.subtitleStyle),
          ),
        ],
      ),
    );
  }
}
