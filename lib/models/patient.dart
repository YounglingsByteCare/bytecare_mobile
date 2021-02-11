import 'dart:convert';

import 'package:flutter/foundation.dart';

/* Poject-level Imports */
// Date Models
import './address.dart';

class PatientModel {
  final String name;
  final String surname;
  final String gender;
  final String idNumber;
  final AddressModel address;
  final String phone;

  PatientModel({
    @required this.name,
    @required this.surname,
    @required this.gender,
    @required this.idNumber,
    this.address,
    this.phone,
  });

  String get fullName => this.name + ' ' + this.surname;

  static PatientModel parse(Map<String, dynamic> data) {
    assert(data.containsKey('name'));
    assert(data.containsKey('surname'));
    assert(data.containsKey('gender'));
    assert(data.containsKey('id_number'));

    return PatientModel(
      name: data['name'],
      surname: data['surname'],
      gender: data['gender'],
      idNumber: data['id_number'],
      address: data.containsKey('address') ? data['address'] : null,
      phone: data.containsKey('phone_number') ? data['phone_number'] : null,
    );
  }

  Map<String, dynamic> asMap() {
    return {
      'name': name,
      'surname': surname,
      'gender': gender,
      'id_number': idNumber,
      'address': address.asMap(),
      'phone': phone,
    };
  }

  @override
  String toString() {
    return jsonEncode(this.asMap());
  }
}
