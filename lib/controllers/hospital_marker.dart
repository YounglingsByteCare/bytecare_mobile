import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';

/* Project-level Imports */
// Data Models
import '../models/api_result.dart';
import '../models/hospital.dart';

// Services
import '../services/byte_care_api.dart';

class HospitalMarkerController extends ChangeNotifier {
  final Uuid uuid = Uuid();
  final BitmapDescriptor markerIcon;

  Map<String, HospitalModel> _hospitals;
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

  Map<String, HospitalModel> get hospitals => _hospitals;

  void clearHospitals() {
    _hospitals.clear();
    notifyListeners();
  }

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

    notifyListeners();
  }

  Future<ApiResultModel> loadHospitals() async {
    var api = ByteCareApi.getInstance();
    var result;

    try {
      result = await api.getHospitals();
    } on ServerNotAvailableException {
      throw ServerNotAvailableException();
    }

    if (result.code != 200) {
      return result;
    }

    List<dynamic> data = result.data;
    Map<String, HospitalModel> updated = {};

    data.forEach((e) {
      var id = e['_id']['\$oid'];
      updated[id] = HospitalModel(
        id: id,
        name: e['hospital_name'],
        location: LatLng(e['point'][0], e['point'][1]),
      );
    });

    _hospitals = updated;
    notifyListeners();
    return result.copyWith(data: updated);
  }

  HospitalModel getHospital(String id) {
    if (!_hospitals.containsKey(id)) {
      return _hospitals[id];
    }
    throw ArgumentError('Marker with MarkerId `$id` does not exist.');
  }

  void addHospitals(Iterable<HospitalModel> m) {
    for (var hospital in m) {
      if (!_hospitals.containsKey(hospital.id)) {
        _hospitals[hospital.id] = hospital;
      }
    }

    notifyListeners();
  }

  void addHospital(HospitalModel m) {
    if (!_hospitals.containsKey(m.id)) {
      _hospitals[m.id] = m;

      notifyListeners();
    }
  }

  void upsertHospital(HospitalModel m) {
    _hospitals[m.id] = m;
    notifyListeners();
  }

  void updateHospital(HospitalModel m) {
    if (!_hospitals.containsKey(m.id)) {
      _hospitals[m.id] = m;

      notifyListeners();
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
