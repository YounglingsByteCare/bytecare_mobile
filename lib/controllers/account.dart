import 'package:bytecare_mobile/models/address.dart';
import 'package:flutter/foundation.dart';
import 'package:enum_to_string/enum_to_string.dart';

/* Project-level Imports */
// Models
import '../models/api_result.dart';
import '../models/appointment.dart';
import '../models/hospital.dart';
import '../models/patient.dart';

// Services
import '../services/byte_care_api.dart';

class AccountController extends ChangeNotifier {
  String _authToken;
  String email;
  Map<String, PatientModel> _patients;
  Map<String, AppointmentModel> _appointments;

  String get token => _authToken;

  set token(String token) {
    if (token != null && token.isNotEmpty) _authToken = token;
  }

  void removeToken() => _authToken = null;

  List<PatientModel> get patients => _patients.values.toList();

  List<AppointmentModel> get appointments => _appointments.values.toList();

  bool hasAppointments() => _appointments != null && _appointments.length > 0;

  bool get hasPatients => _patients != null && _patients.isNotEmpty;

  AppointmentModel getAppointmentForPatient(PatientModel patient) {
    for (AppointmentModel a in _appointments.values) {
      if (a.patientSelected == patient) {
        return a;
      }
    }

    return null;
  }

  Set<PatientModel> get bookedPatients {
    Set<PatientModel> p = {};

    for (AppointmentModel a in _appointments.values) {
      p.add(a.patientSelected);
    }

    return p;
  }

  Set<PatientModel> get availablePatients {
    Set<PatientModel> p = _patients.values.toSet();

    for (AppointmentModel a in _appointments.values) {
      if (p.contains(a.patientSelected)) p.remove(a.patientSelected);
    }

    return p;
  }

  Future<ApiResultModel> register(
    String email,
    String password, [
    bool shouldLogin = false,
  ]) async {
    var api = ByteCareApi.getInstance();
    var result;

    try {
      result = await api.signup(email, password);
    } on ServerNotAvailableException {
      throw ServerNotAvailableException();
    }

    if (result.code != 200) {
      return result;
    }

    if (shouldLogin) {
      return await login(email, password);
    } else {
      return result;
    }
  }

  Future<ApiResultModel> login(
    String email,
    String password, [
    bool storeToken = true,
  ]) async {
    var api = ByteCareApi.getInstance();
    var result;

    try {
      result = await api.login(email, password);
    } on ServerNotAvailableException {
      throw ServerNotAvailableException();
    }

    this.token = result.data['token'];

    notifyListeners();
    return result;
  }

  void logout() {
    this.removeToken();
  }

  Future<ApiResultModel> bookAppointment(AppointmentModel model) async {
    var api = ByteCareApi.getInstance();
    var result;

    try {
      result = await api.postAppointments(token, model);
    } on ServerNotAvailableException {
      throw ServerNotAvailableException();
    }

    if (result.code == 200) {
      _appointments[result.data['_id']] = AppointmentModel(
        id: result.data['id'],
        patientSelected: model.patientSelected,
        hospitalSelected: model.hospitalSelected,
        date: model.date,
        wardType: model.wardType,
        reason: model.reason,
      );
    }

    return result;
  }

  Future<ApiResultModel> cancelAppointment(String appointmentId) async {
    var api = ByteCareApi.getInstance();
    var result;

    try {
      result = await api.deleteAppointment(token, appointmentId);
    } on ServerNotAvailableException {
      throw ServerNotAvailableException();
    }

    if (result.code == 200) {
      _appointments.remove(appointmentId);
    }

    return result;
  }

  Future<ApiResultModel> loadUser(Map<String, HospitalModel> hospitals) async {
    var api = ByteCareApi.getInstance();
    var result;

    try {
      result = await api.getUserData(this._authToken);
    } on ServerNotAvailableException {
      throw ServerNotAvailableException();
    }

    if (result.code != 200) {
      return result;
    }

    print(result.data);
    Map<String, dynamic> data = result.data;

    var patients = Map<String, PatientModel>.fromIterable(
      data['patients'],
      key: (e) => e['_id'],
      value: (e) {
        AddressModel address = AddressModel(
          houseNumber: e['address']['house_number'],
          street: e['address']['street_name'],
          city: e['address']['city'],
          country: e['address']['country'],
          postalCode: e['address']['postal_code'],
        );

        return PatientModel(
          name: e['name'],
          surname: e['surname'],
          gender: e['gender'],
          idNumber: e['_id'],
          address: address,
          phone: e['phone'],
        );
      },
    );

    var appointments = Map<String, AppointmentModel>.fromIterable(
      data['appointments'],
      key: (e) => e['_id']['\$oid'],
      value: (e) {
        var patientId = e['patient_selected'];
        var hospitalId = e['hospital_selected']['\$oid'];

        return AppointmentModel(
          id: e['_id']['\$oid'],
          patientSelected: patients[patientId],
          hospitalSelected: hospitals[hospitalId],
          date: DateTime.fromMillisecondsSinceEpoch(
            e['appointment_date']['\$date'],
            isUtc: true,
          ),
          wardType: EnumToString.fromString(
            WardType.values,
            e['ward_type'],
            camelCase: true,
          ),
          reason: e['reason_for_visit'],
        );
      },
    );

    email = data['email'];
    _patients = patients;
    _appointments = appointments;

    print('--- Displaying User Data');
    print(email);
    print(_patients);
    print(_appointments);
    print('--- END ---');

    notifyListeners();

    return result.copyWith(data: {
      'email': email,
      'patients': patients,
      'appointments': appointments,
    });
  }

  Future<ApiResultModel> createPatient(PatientModel model) async {
    var api = ByteCareApi.getInstance();
    var result;

    try {
      result = await api.postPatients(token, model);
    } on ServerNotAvailableException {
      throw ServerNotAvailableException();
    }

    if (result.code == 200) {
      _patients[result.data['_id']] = model;
    }

    return result;
  }

  Future<ApiResultModel> loadPatients() async {
    var api = ByteCareApi.getInstance();
    var result;

    try {
      result = await api.getPatients(this._authToken);
    } on ServerNotAvailableException {
      throw ServerNotAvailableException();
    }

    if (result.code != 200) {
      return result;
    }

    var patients = Map<String, PatientModel>.fromIterable(
      result.data,
      key: (e) => e['_id'],
      value: (e) {
        AddressModel address = AddressModel(
          houseNumber: e['house_number'],
          street: e['street_name'],
          city: e['city'],
          country: e['country'],
          postalCode: e['postal_code'],
        );

        return PatientModel(
          name: e['name'],
          surname: e['surname'],
          gender: e['gender'],
          idNumber: e['_id'],
          address: address,
          phone: e['phone'],
        );
      },
    );

    _patients = patients;
    notifyListeners();
    return result.copyWith(data: patients);
  }

  // Future<PatientModel> loadPatient(String patientId) async {
  //   var api = ByteCareApi.getInstance();
  //   var result;
  //
  //   try {
  //     result = await api.getPatient(this._authToken, patientId);
  //   } on ServerNotAvailableException {
  //     throw ServerNotAvailableException();
  //   }
  // }

  Future<ApiResultModel> loadAppointments(
      Map<String, HospitalModel> hospitals) async {
    if (_patients == null) {
      return Future.error('No patients available.');
    }

    if (_patients.length == 0) {
      return ApiResultModel(
        code: 404,
        message: 'No patients available for appointments.',
        hasError: false,
      );
    }

    var api = ByteCareApi.getInstance();
    var result;

    try {
      result = await api.getAppointments(this._authToken);
    } on ServerNotAvailableException {
      throw ServerNotAvailableException();
    }

    if (result.code != 200) {
      return result;
    }

    var appointments = Map<String, AppointmentModel>.fromIterable(
      result.data,
      key: (e) => e['_id']['\$oid'],
      value: (e) {
        String patientId = e['patient_selected'];
        String hospitalId = e['hospital_selected']['\$oid'];

        return AppointmentModel(
          id: e['_id']['\$oid'],
          patientSelected: _patients[patientId],
          hospitalSelected: hospitals[hospitalId],
          date: e['appointment_date']['\$date'],
          wardType: EnumToString.fromString(
            WardType.values,
            e['ward_type'],
            camelCase: true,
          ),
          reason: e['reason_for_visit'],
        );
      },
    );

    _appointments = appointments;
    notifyListeners();
    return result.copyWith(data: appointments);
  }
}
