import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';

/* Project-level Imports */
// Data Models
import '../models/hospital.dart';

class HospitalMarkerController {
  final Uuid uuid = Uuid();
  final BitmapDescriptor markerIcon;

  Map<MarkerId, HospitalModel> _hospitals;
  void Function(HospitalModel) onTap;
  Marker _userMarker;

  HospitalMarkerController({
    this.onTap,
    this.markerIcon = BitmapDescriptor.defaultMarker,
  }) : _hospitals = {};

  HospitalMarkerController.withUser({
    @required Marker userMarker,
    this.markerIcon = BitmapDescriptor.defaultMarker,
    this.onTap,
  })  : _hospitals = {},
        _userMarker = userMarker;

  void clearHospitals() => _hospitals.clear();

  set userLocation(LatLng location) => updateUserMarker(position: location);

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
    assert(_userMarker != null);
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

  HospitalModel getHospital(MarkerId id) {
    if (!_hospitals.containsKey(id)) {
      return _hospitals[id];
    }
    throw ArgumentError('Marker with MarkerId `$id` does not exist.');
  }

  void addHospitals(Iterable<HospitalModel> m) {
    for (var hospital in m) {
      var id = MarkerId(hospital.id);
      if (!_hospitals.containsKey(id)) {
        _hospitals[id] = hospital;
      }
    }
  }

  void addHospital(HospitalModel m) {
    var id = MarkerId(m.id);
    if (!_hospitals.containsKey(id)) {
      _hospitals[id] = m;
    }
  }

  void upsertHospital(HospitalModel m) {
    var id = MarkerId(m.id);
    _hospitals[id] = m;
  }

  void updateHospital(HospitalModel m) {
    var id = MarkerId(m.id);
    if (!_hospitals.containsKey(id)) {
      _hospitals[id] = m;
    }
  }

  Set<HospitalModel> asHospitalSet() {
    return _hospitals.values.toSet();
  }

  Set<Marker> asMarkerSet([bool includeUser]) {
    var result = _hospitals.values.map((value) {
      return value.toMarker(
        icon: markerIcon,
        onTap: () => onTap(value),
      );
    }).toSet();

    if (includeUser) {
      result.add(_userMarker);
    }

    return result;
  }
}
