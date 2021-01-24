import 'package:flutter/material.dart';

/* Project-level Imports */
// Models
import '../models/hospital.dart';
import '../models/patient.dart';

enum WardType {
  General,
  SemiPrivate,
  Private,
}

class AppointmentModel {
  final PatientModel patientSelected;
  final HospitalModel hospitalSelected;
  final DateTime date;
  final WardType wardType;
  final String reason;

  AppointmentModel({
    @required this.patientSelected,
    @required this.hospitalSelected,
    @required this.date,
    @required this.wardType,
    @required this.reason,
  });

  static AppointmentModel parse(Map<String, dynamic> data) {
    assert(data.containsKey('patient_selected'));
    assert(data.containsKey('hospital_selected'));
    assert(data.containsKey('appointment_date'));
    assert(data.containsKey('ward_type'));
    assert(data.containsKey('reason_for_visit'));
  }
}
