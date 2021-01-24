import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HospitalModel {
  final String id;
  final String name;
  final LatLng location;

  HospitalModel({
    @required this.id,
    @required this.name,
    @required this.location,
  });

  Marker toMarker({
    double alpha = 1.0,
    Offset anchor = const Offset(0.5, 1.0),
    bool consumeTapEvents = false,
    bool draggable = false,
    bool flat = false,
    BitmapDescriptor icon = BitmapDescriptor.defaultMarker,
    double rotation = 0.0,
    bool visible = true,
    double zIndex = 0.0,
    void Function() onTap,
    void Function(LatLng) onDragEnd,
  }) {
    return Marker(
      markerId: MarkerId(id),
      alpha: alpha,
      anchor: anchor,
      consumeTapEvents: consumeTapEvents,
      draggable: draggable,
      flat: flat,
      icon: icon,
      position: location,
      infoWindow: InfoWindow(title: name),
      rotation: rotation,
      visible: visible,
      zIndex: zIndex,
      onTap: onTap,
      onDragEnd: onDragEnd,
    );
  }
}
