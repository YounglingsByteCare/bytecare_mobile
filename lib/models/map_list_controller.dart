import 'package:flutter/material.dart';

enum MapListType { Map, List }

class MapListController {
  final IconData mapIcon;
  final IconData listIcon;
  bool isLocked = false;
  MapListType type;

  MapListController({
    @required this.mapIcon,
    @required this.listIcon,
    MapListType initialType,
  }) : type = initialType ?? MapListType.Map;

  bool get isShowingMap => type == MapListType.Map;

  bool get isShowingList => type == MapListType.List;

  IconData getAppropriateIconData() => isShowingMap ? mapIcon : listIcon;

  void toggleView() {
    if (isLocked) return;
    type = type == MapListType.Map ? MapListType.List : MapListType.Map;
  }
}
