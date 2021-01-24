import 'package:flutter/material.dart';

enum MapView { MAP, LIST }

class MapViewController extends ChangeNotifier {
  final IconData mapIcon;
  final IconData listIcon;
  MapView view;

  MapViewController({
    @required this.mapIcon,
    @required this.listIcon,
    this.view = MapView.MAP,
  });

  bool isShowing(MapView v) => view == v;

  IconData get currentIcon => isShowing(MapView.MAP) ? mapIcon : listIcon;

  void toggleView() {
    view = (view == MapView.MAP) ? MapView.LIST : MapView.MAP;
    notifyListeners();
  }
}
