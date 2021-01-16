import 'package:flutter/material.dart';

enum MapListType { Map, List }

class MapListController {
  final IconData mapIcon;
  final IconData listIcon;
  MapListType type;

  MapListController({
    @required this.mapIcon,
    @required this.listIcon,
    MapListType initialType,
  }) : type = initialType ?? MapListType.Map;

  bool get isShowingMap => type == MapListType.Map;

  bool get isShowingList => type == MapListType.List;

  IconData getAppropriateIconData() => isShowingMap ? mapIcon : listIcon;
}
