import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';

class HospitalMarker implements Marker {
  final String _hospitalId;
  final String _hospitalName;
  final LatLng _hospitalCoords;

  Marker _internalMarker;
  Uuid _uuid;

  HospitalMarker({
    @required MarkerId markerId,
    @required String hospitalId,
    @required String hospitalName,
    @required LatLng position,
    Offset anchor,
    BitmapDescriptor icon,
    void Function(HospitalMarker) onTap,
    void Function() onMarkerTap,
  })  : _hospitalId = hospitalId,
        _hospitalName = hospitalName,
        _hospitalCoords = position {
    _internalMarker = Marker(
      markerId: markerId,
      anchor: anchor ?? const Offset(0.5, 1.0),
      icon: icon ?? BitmapDescriptor.defaultMarker,
      infoWindow: InfoWindow(
        title: hospitalName,
      ),
      position: position,
      onTap: onTap != null ? () => (onTap ?? (m) {})(this) : onMarkerTap,
    );
  }

  String get hospitalId => _hospitalId;

  String get hospitalName => _hospitalName;

  LatLng get coords => _hospitalCoords;

  @override
  double get alpha => _internalMarker.alpha;

  @override
  Offset get anchor => _internalMarker.anchor;

  @override
  Marker clone() => _internalMarker.clone();

  @override
  // TODO: implement consumeTapEvents
  bool get consumeTapEvents => _internalMarker.consumeTapEvents;

  @override
  Marker copyWith(
      {double alphaParam,
      Offset anchorParam,
      bool consumeTapEventsParam,
      bool draggableParam,
      bool flatParam,
      BitmapDescriptor iconParam,
      InfoWindow infoWindowParam,
      LatLng positionParam,
      double rotationParam,
      bool visibleParam,
      double zIndexParam,
      onTapParam,
      onDragEndParam}) {
    // TODO: implement copyWith
    return _internalMarker.copyWith(
      alphaParam: alphaParam,
      anchorParam: anchorParam,
      consumeTapEventsParam: consumeTapEventsParam,
      draggableParam: draggableParam,
      flatParam: flatParam,
      iconParam: iconParam,
      infoWindowParam: infoWindowParam,
      positionParam: positionParam,
      rotationParam: rotationParam,
      visibleParam: visibleParam,
      zIndexParam: zIndexParam,
      onTapParam: onTapParam,
      onDragEndParam: onDragEndParam,
    );
  }

  @override
  // TODO: implement draggable
  bool get draggable => _internalMarker.draggable;

  @override
  // TODO: implement flat
  bool get flat => _internalMarker.flat;

  @override
  // TODO: implement icon
  BitmapDescriptor get icon => _internalMarker.icon;

  @override
  // TODO: implement infoWindow
  InfoWindow get infoWindow => _internalMarker.infoWindow;

  @override
  // TODO: implement markerId
  MarkerId get markerId => _internalMarker.markerId;

  @override
  // TODO: implement onDragEnd
  get onDragEnd => _internalMarker.onDragEnd;

  @override
  // TODO: implement onTap
  get onTap => _internalMarker.onTap;

  @override
  // TODO: implement position
  LatLng get position => _internalMarker.position;

  @override
  // TODO: implement rotation
  double get rotation => _internalMarker.rotation;

  @override
  Map<String, dynamic> toJson() => _internalMarker.toJson();

  @override
  // TODO: implement visible
  bool get visible => _internalMarker.visible;

  @override
  // TODO: implement zIndex
  double get zIndex => _internalMarker.zIndex;
}
