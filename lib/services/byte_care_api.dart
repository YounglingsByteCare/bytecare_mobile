import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;

/* Project-level Imports */
// Data Models
import '../models/api_result.dart';
import '../models/appointment.dart';
import '../models/patient.dart';

class ServerNotAvailableException extends Error {}

class ByteCareApi {
  static ByteCareApi _instance;

  static const String namespace = 'api';

  static ByteCareApi getInstance() => _instance;

  static void init(Uri host, [http.Client client]) {
    _instance = ByteCareApi._(host, client);
  }

  final Map<String, Uri> routes = {
    'status': Uri(pathSegments: [namespace, 'status']),
    'signup': Uri(pathSegments: [namespace, 'auth', 'signup']),
    'login': Uri(pathSegments: [namespace, 'auth', 'login']),
    'verify': Uri(pathSegments: [namespace, 'auth', 'verify']),
    'forgotPassword': Uri(pathSegments: [namespace, 'auth', 'forgot']),
    'user': Uri(pathSegments: [namespace, 'user']),
    'patient': Uri(pathSegments: [namespace, 'patient', '<id>']),
    'patients': Uri(pathSegments: [namespace, 'patients']),
    'appointment': Uri(pathSegments: [namespace, 'appointment', '<id>']),
    'appointments': Uri(pathSegments: [namespace, 'appointments']),
    'hospitals': Uri(pathSegments: [namespace, 'hospitals']),
  };

  Uri _hostUri;
  http.Client _httpClient;
  Duration timeoutDuration = Duration(seconds: 20);

  ByteCareApi._(Uri hostUri, [http.Client client])
      : _hostUri = hostUri,
        _httpClient = client ?? http.Client();

  void close() {
    _httpClient.close();
  }

  Uri getFullUrl([String subdir, Map<String, String> arguments]) {
    if (subdir == null || subdir.isEmpty) {
      return _hostUri;
    }

    if (!routes.containsKey(subdir)) {
      throw ArgumentError('The key `$subdir` does not exist in the routes.');
    }

    var routePath = routes[subdir].pathSegments;

    return _hostUri.resolveUri(
      Uri(
          pathSegments: routePath.map((el) {
        if (el.startsWith('<') && el.endsWith('>')) {
          var arg = el.substring(1, el.length - 1);
          if (arguments.containsKey(arg)) {
            return arguments[arg];
          } else {
            return el;
          }
        }
        return el;
      }).toList()),
    );
  }

  Future<bool> testConnection() async {
    var url = getFullUrl('status');
    try {
      var result = await _httpClient.head(url).timeout(Duration(seconds: 10));
      if (result.statusCode == 200) return true;
    } on SocketException {
      return false;
    } on TimeoutException {
      return false;
    }

    return false;
  }

  /* Authorisation `auth` Functions */
  Future<ApiResultModel> signup(String emailAddress, String password) async {
    var url = getFullUrl('signup');
    var body = {
      'email': emailAddress,
      'password': password,
    };
    var headers = {
      'Content-Type': 'application/json',
    };

    var result;

    try {
      result = await _httpClient
          .post(url, body: jsonEncode(body), headers: headers)
          .timeout(Duration(seconds: 10));
    } on SocketException {
      throw ServerNotAvailableException();
    } on TimeoutException {
      throw ServerNotAvailableException();
    }

    if (result.statusCode == 200) {
      return ApiResultModel(
        code: result.statusCode,
        data: jsonDecode(result.body),
        hasError: false,
      );
    } else {
      if (result.body is String && result.body.startsWith('<!DOCTYPE HTML')) {
        return ApiResultModel(
          code: result.statusCode,
          message: 'Failed to register user',
          hasError: true,
        );
      } else {
        return ApiResultModel(
          code: result.statusCode,
          message: jsonDecode(result.body)['message'],
          hasError: true,
        );
      }
    }
  }

  Future<ApiResultModel> login(String emailAddress, String password) async {
    var url = getFullUrl('login');
    var body = {'email': emailAddress, 'password': password};
    var headers = {'Content-Type': 'application/json'};

    var result;

    try {
      result = await _httpClient
          .post(url, body: jsonEncode(body), headers: headers)
          .timeout(timeoutDuration);
    } on SocketException {
      throw ServerNotAvailableException();
    } on TimeoutException {
      throw ServerNotAvailableException();
    }

    if (result.statusCode == 200) {
      return ApiResultModel(
        code: result.statusCode,
        data: jsonDecode(result.body),
        hasError: false,
      );
    } else {
      if (result.body is String && result.body.startsWith('<!DOCTYPE HTML')) {
        return ApiResultModel(
          code: result.statusCode,
          message: 'Failed to login user.',
          hasError: true,
        );
      } else {
        return ApiResultModel(
          code: result.statusCode,
          message: jsonDecode(result.body)['message'],
          hasError: true,
        );
      }
    }
  }

  Future<ApiResultModel> verifyUser(String token) async {
    var url = getFullUrl('verify');
    var headers = {
      'Authorization': 'Bearer $token',
    };

    var result;

    try {
      result = await _httpClient
          .post(url, headers: headers)
          .timeout(timeoutDuration);
    } on SocketException {
      throw ServerNotAvailableException();
    } on TimeoutException {
      throw ServerNotAvailableException();
    }

    if (result.statusCode == 200) {
      return ApiResultModel(
        code: result.statusCode,
        data: jsonDecode(result.body),
        hasError: false,
      );
    } else {
      if (result.body is String && result.body.startsWith('<!DOCTYPE HTML')) {
        return ApiResultModel(
          code: result.statusCode,
          message: 'Failed to login user.',
          hasError: true,
        );
      } else {
        return ApiResultModel(
          code: result.statusCode,
          message: jsonDecode(result.body)['message'],
          hasError: true,
        );
      }
    }
  }

  Future<ApiResultModel> forgotPassword(String emailAddress) async {
    var url = getFullUrl('forgotPassword');
    var body = {'email': emailAddress};
    var headers = {'Content-Type': 'application/json'};

    var result;

    try {
      result = await _httpClient
          .post(url, body: jsonEncode(body), headers: headers)
          .timeout(timeoutDuration);
    } on SocketException {
      throw ServerNotAvailableException();
    } on TimeoutException {
      throw ServerNotAvailableException();
    }

    if (result.statusCode == 200) {
      return ApiResultModel(
        code: result.statusCode,
        message: jsonDecode(result.body)['message'],
        hasError: false,
      );
    } else {
      if (result.body is String && result.body.startsWith('<!DOCTYPE HTML')) {
        return ApiResultModel(
          code: result.statusCode,
          message: 'Failed to send forget request',
          hasError: true,
        );
      } else {
        return ApiResultModel(
          code: result.statusCode,
          message: jsonDecode(result.body)['message'],
          hasError: true,
        );
      }
    }
  }

  // void resetPassword() async {}

  /* User Functions */
  Future<ApiResultModel> getUserData(String token) async {
    var url = getFullUrl('user');
    var headers = {'Authorization': 'Bearer $token'};

    var result;

    try {
      result =
          await _httpClient.get(url, headers: headers).timeout(timeoutDuration);
    } on SocketException {
      throw ServerNotAvailableException();
    } on TimeoutException {
      throw ServerNotAvailableException();
    }

    if (result.statusCode == 200) {
      return ApiResultModel(
        code: result.statusCode,
        data: jsonDecode(result.body),
        hasError: false,
      );
    } else {
      if (result.body is String && result.body.startsWith('<!DOCTYPE HTML')) {
        return ApiResultModel(
          code: result.statusCode,
          message: 'Failed to get user Data',
          hasError: true,
        );
      } else {
        return ApiResultModel(
          code: result.statusCode,
          message: jsonDecode(result.body)['message'],
          hasError: true,
        );
      }
    }
  }

  // void updateUserData() async {}
  // void deleteUser() async {}

  /* User Address Function */
  // void getUserAddresses() async {}
  // void addUserAddress() async {}
  // void updateUserAddress() async {}
  // void removeUserAddress() async {}

  /* User Contact Functions */
  // void getUserContacts() async {}

  /* Patients Functions */
  Future<ApiResultModel> getPatients(String token) async {
    var url = getFullUrl('patients');
    var headers = {'Authorization': 'Bearer $token'};

    var result;

    try {
      result =
          await _httpClient.get(url, headers: headers).timeout(timeoutDuration);
    } on SocketException {
      throw ServerNotAvailableException();
    } on TimeoutException {
      throw ServerNotAvailableException();
    }

    if (result.statusCode == 200) {
      return ApiResultModel(
        code: result.statusCode,
        data: jsonDecode(result.body),
        hasError: false,
      );
    } else {
      if (result.body is String && result.body.startsWith('<!DOCTYPE HTML')) {
        return ApiResultModel(
          code: result.statusCode,
          message: 'Failed to get patient data',
          hasError: true,
        );
      } else {
        return ApiResultModel(
          code: result.statusCode,
          message: jsonDecode(result.body)['message'],
          hasError: true,
        );
      }
    }
  }

  Future<ApiResultModel> postPatients(String token, PatientModel model) async {
    var url = getFullUrl('patients');
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    var body = model.asMap();

    var result;

    try {
      result = await _httpClient
          .post(url, headers: headers, body: jsonEncode(body))
          .timeout(timeoutDuration);
    } on SocketException {
      throw ServerNotAvailableException();
    } on TimeoutException {
      throw ServerNotAvailableException();
    }

    if (result.statusCode == 200) {
      return ApiResultModel(
        code: result.statusCode,
        data: jsonDecode(result.body),
        hasError: false,
      );
    } else {
      if (result.body is String && result.body.startsWith('<!DOCTYPE HTML')) {
        return ApiResultModel(
          code: result.statusCode,
          message: 'Failed to create patient',
          hasError: true,
        );
      } else {
        return ApiResultModel(
          code: result.statusCode,
          message: jsonDecode(result.body)['message'],
          hasError: true,
        );
      }
    }
  }

  Future<ApiResultModel> getPatient(String token, String patientId) async {
    var url = getFullUrl('patient', {'id': patientId});
    var headers = {
      'Authorization': 'Bearer $token',
    };

    var result;

    try {
      result =
          await _httpClient.get(url, headers: headers).timeout(timeoutDuration);
    } on SocketException {
      throw ServerNotAvailableException();
    } on TimeoutException {
      throw ServerNotAvailableException();
    }

    if (result.statusCode == 200) {
      return ApiResultModel(
        code: result.statusCode,
        data: jsonDecode(result.body),
        hasError: false,
      );
    } else {
      if (result.body is String && result.body.startsWith('<!DOCTYPE HTML')) {
        return ApiResultModel(
          code: result.statusCode,
          message: 'Failed to get patient data',
          hasError: true,
        );
      } else {
        return ApiResultModel(
          code: result.statusCode,
          message: jsonDecode(result.body)['message'],
          hasError: true,
        );
      }
    }
  }

  Future<ApiResultModel> deletePatient(String token, String patientId) async {
    var url = getFullUrl('patients', {'id': patientId});
    var headers = {
      'Authorization': 'Bearer $token',
    };

    var result;

    try {
      result = await _httpClient
          .delete(url, headers: headers)
          .timeout(timeoutDuration);
    } on SocketException {
      throw ServerNotAvailableException;
    } on TimeoutException {
      throw ServerNotAvailableException;
    }

    if (result.statusCode == 200) {
      return ApiResultModel(
        code: result.statusCode,
        data: jsonDecode(result.body),
        hasError: false,
      );
    } else {
      if (result.body is String && result.body.startsWith('<!DOCTYPE HTML')) {
        return ApiResultModel(
          code: result.statusCode,
          message: 'Failed to delete patient.',
          hasError: true,
        );
      } else {
        return ApiResultModel(
          code: result.statusCode,
          message: jsonDecode(result.body)['message'],
          hasError: true,
        );
      }
    }
  }

  /* Hospital Functions */
  Future<ApiResultModel> getHospitals() async {
    var url = getFullUrl('hospitals');

    var result;

    try {
      result = await _httpClient.get(url).timeout(timeoutDuration);
    } on SocketException {
      throw ServerNotAvailableException();
    } on TimeoutException {
      throw ServerNotAvailableException();
    }

    if (result.statusCode == 200) {
      return ApiResultModel(
        code: result.statusCode,
        data: jsonDecode(result.body),
        hasError: false,
      );
    } else {
      if (result.body is String && result.body.startsWith('<!DOCTYPE HTML')) {
        return ApiResultModel(
          code: result.statusCode,
          message: 'Failed to get hospital data',
          hasError: true,
        );
      } else {
        return ApiResultModel(
          code: result.statusCode,
          message: jsonDecode(result.body)['message'],
          hasError: true,
        );
      }
    }
  }

  /* Appointment Functions */
  Future<ApiResultModel> getAppointments(String token) async {
    var url = getFullUrl('appointments');
    var headers = {'Authorization': 'Bearer $token'};

    var result;

    try {
      result =
          await _httpClient.get(url, headers: headers).timeout(timeoutDuration);
    } on SocketException {
      throw ServerNotAvailableException();
    } on TimeoutException {
      throw ServerNotAvailableException();
    }

    if (result.statusCode == 200) {
      return ApiResultModel(
        code: result.statusCode,
        data: jsonDecode(result.body),
        hasError: false,
      );
    } else {
      if (result.body is String && result.body.startsWith('<!DOCTYPE HTML')) {
        return ApiResultModel(
          code: result.statusCode,
          message: 'Failed to get appointment data',
          hasError: true,
        );
      } else {
        return ApiResultModel(
          code: result.statusCode,
          message: jsonDecode(result.body)['message'],
          hasError: true,
        );
      }
    }
  }

  Future<ApiResultModel> postAppointments(
      String token, AppointmentModel model) async {
    var url = getFullUrl('appointments');
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    var body = model.asMap();

    var result;

    try {
      result = await _httpClient
          .post(url, body: jsonEncode(body), headers: headers)
          .timeout(timeoutDuration);
    } on SocketException {
      throw ServerNotAvailableException();
    } on TimeoutException {
      throw ServerNotAvailableException();
    }

    if (result.statusCode == 200) {
      return ApiResultModel(
        code: result.statusCode,
        data: jsonDecode(result.body),
        hasError: false,
      );
    } else {
      if (result.body is String && result.body.startsWith('<!DOCTYPE HTML')) {
        return ApiResultModel(
          code: result.statusCode,
          message: 'Failed to book appointment',
          hasError: true,
        );
      } else {
        return ApiResultModel(
          code: result.statusCode,
          message: jsonDecode(result.body),
          hasError: true,
        );
      }
    }
  }

  Future<ApiResultModel> deleteAppointment(
    String token,
    String appointmentId,
  ) async {
    var url = getFullUrl('appointment', {'id': appointmentId});
    var headers = {
      'Authorization': 'Bearer $token',
    };

    var result;

    try {
      result = await _httpClient
          .delete(url, headers: headers)
          .timeout(timeoutDuration);
    } on SocketException {
      throw ServerNotAvailableException();
    } on TimeoutException {
      throw ServerNotAvailableException();
    }

    if (result.statusCode == 200) {
      return ApiResultModel(
        code: result.statusCode,
        data: jsonDecode(result.body),
        hasError: false,
      );
    } else {
      if (result.body is String && result.body.startsWith('<!DOCTYPE HTML')) {
        return ApiResultModel(
          code: result.statusCode,
          message: 'Failed to delete appointment',
          hasError: true,
        );
      } else {
        return ApiResultModel(
          code: result.statusCode,
          message: jsonDecode(result.body)['message'],
          hasError: true,
        );
      }
    }
  }
}
