import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/* Project-level Import */
// Models
import '../models/patient.dart';
import '../models/appointment.dart';
import '../models/hospital.dart';

// Controllers
import '../controllers/hospital_marker.dart';

class ByteCareApiNotifier extends ChangeNotifier {
  String authToken;
  HospitalMarkerController _hospitalController;
  List<PatientModel> _patients;
  List<AppointmentModel> _appointments;

  ByteCareApiNotifier()
      : _patients = [],
        _appointments = [];

  void setHospitalController(HospitalMarkerController controller) {
    _hospitalController = controller;
  }

  void initPatients(Iterable<PatientModel> p) {
    _patients = p.toList();
  }

  void initAppointments(Iterable<AppointmentModel> a) {
    _appointments = a.toList();
  }

  Set<Marker> get markers => _hospitalController.asMarkerSet(true);

  Set<HospitalModel> get hospitals => _hospitalController.asHospitalSet();

  HospitalMarkerController get hospitalController => _hospitalController;

  List<PatientModel> get patients => _patients;

  List<AppointmentModel> get appointments => _appointments;
}
