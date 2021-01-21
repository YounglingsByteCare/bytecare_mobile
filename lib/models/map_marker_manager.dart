import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';

/* Project-level Imports */
// Data Models
import '../models/hospital_marker.dart';

class MapMarkerManager {
  final Uuid uuid = Uuid();

  HospitalMarker _defaultMarker;
  Marker _userMarker;
  Map<MarkerId, HospitalMarker> _markers;

  MapMarkerManager({
    @required HospitalMarker defaultMarker,
  })  : _markers = {},
        _defaultMarker = defaultMarker;

  MapMarkerManager.withUser({
    @required HospitalMarker defaultMarker,
    @required Marker userMarker,
  })  : this._defaultMarker = defaultMarker,
        this._userMarker = userMarker,
        _markers = {};

  void clearMarkers() => _markers.clear();

  void setUserLocation(LatLng position) {
    updateUserMarker(position: position);
  }

  void updateUserMarker({
    double alpha,
    Offset anchor,
    bool allowTaps,
    bool draggable,
    bool flat,
    BitmapDescriptor icon,
    InfoWindow infoWindow,
    LatLng position,
    double rotation,
    bool visible,
    double zIndex,
    void Function() onTap,
    void Function(LatLng) onDragEnd,
  }) {
    _userMarker = _userMarker.copyWith(
      alphaParam: alpha ?? _userMarker.alpha,
      anchorParam: anchor ?? _userMarker.anchor,
      draggableParam: draggable ?? _userMarker.draggable,
      flatParam: flat ?? _userMarker.flat,
      iconParam: icon ?? _userMarker.icon,
      infoWindowParam: infoWindow ?? _userMarker.infoWindow,
      positionParam: position ?? _userMarker.position,
      rotationParam: rotation ?? _userMarker.rotation,
      visibleParam: visible ?? _userMarker.visible,
      zIndexParam: zIndex ?? _userMarker.zIndex,
      onTapParam: onTap ?? _userMarker.onTap,
      onDragEndParam: onDragEnd ?? _userMarker.onDragEnd,
    );
  }

  void updateDefaultMarker({
    LatLng position,
    double alpha,
    Offset anchor,
    bool allowTaps,
    bool draggable,
    bool flat,
    BitmapDescriptor icon,
    InfoWindow infoWindow,
    double rotation,
    bool visible,
    double zIndex,
    void Function() onTap,
    void Function(LatLng) onDragEnd,
  }) {
    _defaultMarker = _defaultMarker.copyWith(
      alphaParam: alpha ?? _defaultMarker.alpha,
      anchorParam: anchor ?? _defaultMarker.anchor,
      draggableParam: draggable ?? _defaultMarker.draggable,
      flatParam: flat ?? _defaultMarker.flat,
      iconParam: icon ?? _defaultMarker.icon,
      infoWindowParam: infoWindow ?? _defaultMarker.infoWindow,
      positionParam: position ?? _defaultMarker.position,
      rotationParam: rotation ?? _defaultMarker.rotation,
      visibleParam: visible ?? _defaultMarker.visible,
      zIndexParam: zIndex ?? _defaultMarker.zIndex,
      onTapParam: onTap ?? _defaultMarker.onTap,
      onDragEndParam: onDragEnd ?? _defaultMarker.onDragEnd,
    );
  }

  void addMarker({
    @required String hospitalId,
    @required String hospitalName,
    @required LatLng position,
    Offset anchor,
    BitmapDescriptor icon,
    void Function(HospitalMarker) onTap,
  }) {
    var id = MarkerId(uuid.v4());

    HospitalMarker m = HospitalMarker(
      markerId: id,
      hospitalId: hospitalId,
      hospitalName: hospitalName,
      anchor: anchor ?? _defaultMarker.anchor,
      icon: icon ?? _defaultMarker.icon,
      position: position,
      onTap: onTap,
      onMarkerTap: _defaultMarker.onTap,
    );

    _markers[id] = m;
  }

  // void updateMarker(
  //   MarkerId markerId, {
  //   @required LatLng position,
  //   double alpha,
  //   Offset anchor,
  //   bool allowTaps,
  //   bool draggable,
  //   bool flat,
  //   BitmapDescriptor icon,
  //   InfoWindow infoWindow,
  //   double rotation,
  //   bool visible,
  //   double zIndex,
  //   void Function() onTap,
  //   void Function(LatLng) onDragEnd,
  // }) {
  //   if (_markers.containsKey(markerId)) {
  //     var original = _markers[markerId];
  //
  //     HospitalMarker m = HospitalMarker(
  //       markerId: markerId,
  //       alpha: alpha ?? original.alpha,
  //       anchor: anchor ?? original.alpha,
  //       draggable: draggable ?? original.draggable,
  //       flat: flat ?? original.flat,
  //       icon: icon ?? original.icon,
  //       infoWindow: infoWindow ?? original.infoWindow,
  //       position: position,
  //       rotation: rotation ?? original.rotation,
  //       visible: visible ?? original.visible,
  //       zIndex: zIndex ?? original.zIndex,
  //       onTap: () {
  //         if (_onMarkerTap != null) _onMarkerTap(markerId);
  //         (onTap ?? original.onTap ?? () {})();
  //       },
  //       onDragEnd: onDragEnd ?? original.onDragEnd,
  //     );
  //
  //     _markers[markerId] = m;
  //   } else {
  //     throw ArgumentError('The provided MarkerId `$markerId` does not exist.');
  //   }
  // }

  HospitalMarker getMarker(MarkerId markerId) {
    if (_markers.containsKey(markerId)) {
      return _markers[markerId];
    } else {
      throw ArgumentError('Marker with MarkerId `$markerId` does not exist.');
    }
  }

  Map<MarkerId, Marker> asMap([bool includeUser]) {
    Map<MarkerId, Marker> out = Map<MarkerId, Marker>.from(_markers);
    if (includeUser && _userMarker != null) {
      out[_userMarker.markerId] = _userMarker;
    }
    return out;
  }

  Set<Marker> asSet([bool includeUser]) {
    Set<Marker> out = Set<Marker>();

    if (includeUser && _userMarker != null) {
      out.add(_userMarker);
    }

    _markers.forEach((key, value) {
      out.add(value);
    });

    return out;
  }
}
