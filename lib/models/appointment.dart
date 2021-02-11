import 'package:flutter/material.dart';
import 'package:enum_to_string/enum_to_string.dart';

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
  final String id;
  final PatientModel patientSelected;
  final HospitalModel hospitalSelected;
  final DateTime date;
  final WardType wardType;
  final String reason;

  AppointmentModel({
    @required this.id,
    @required this.patientSelected,
    @required this.hospitalSelected,
    @required this.date,
    @required this.wardType,
    @required this.reason,
  });

  Map<String, dynamic> asMap([bool includeId = false]) {
    if (includeId) {
      return {
        'id': id,
        'patient_selected': patientSelected.idNumber,
        'hospital_selected': hospitalSelected.id,
        'appointment_date': date.toUtc().toIso8601String(),
        'ward_type': EnumToString.convertToString(wardType),
        'reason_for_visit': reason,
      };
    } else {
      return {
        'patient_selected': patientSelected.idNumber,
        'hospital_selected': hospitalSelected.id,
        'appointment_date': date.toUtc().toIso8601String(),
        'ward_type': EnumToString.convertToString(wardType),
        'reason_for_visit': reason,
      };
    }
  }
}
