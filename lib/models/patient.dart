import 'package:flutter/foundation.dart';

class PatientModel {
  final String name;
  final String surname;
  final String gender;
  final String idNumber;
  final Map<String, String> address;
  final String phone;

  PatientModel({
    @required this.name,
    @required this.surname,
    @required this.gender,
    @required this.idNumber,
    this.address,
    this.phone,
  });

  static PatientModel parse(Map<String, dynamic> data) {
    assert(data.containsKey('name'));
    assert(data.containsKey('surname'));
    assert(data.containsKey('gender'));
    assert(data.containsKey('idNumber'));

    return PatientModel(
      name: data['name'],
      surname: data['surname'],
      gender: data['gender'],
      idNumber: data['id_number'],
      address: data.containsKey('address') ? data['address'] : null,
      phone: data.containsKey('phone_number') ? data['phone_number'] : null,
    );
  }
}
