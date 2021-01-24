import 'dart:convert';

import 'package:http/http.dart' as http;

/* Project-level Imports */
// Data Models
import '../models/api_result.dart';

class ByteCareApi {
  static ByteCareApi _instance;

  static const String namespace = 'api';

  static ByteCareApi getInstance() => _instance;

  static void init(Uri host, [http.Client client]) {
    _instance = ByteCareApi._(host, client);
  }

  final Map<String, Uri> routes = {
    'signup': Uri(pathSegments: [namespace, 'auth', 'signup']),
    'login': Uri(pathSegments: [namespace, 'auth', 'login']),
    'forgotPassword': Uri(pathSegments: [namespace, 'auth', 'forgot']),
    'patient': Uri(pathSegments: [namespace, 'patient', '<id>']),
    'patients': Uri(pathSegments: [namespace, 'patients']),
    'appointment': Uri(pathSegments: [namespace, 'appointment', '<id>']),
    'appointments': Uri(pathSegments: [namespace, 'appointments']),
    'hospitals': Uri(pathSegments: [namespace, 'hospitals']),
  };

  Uri _hostUri;
  http.Client _httpClient;

  ByteCareApi._(Uri hostUri, [http.Client client])
      : _hostUri = hostUri,
        _httpClient = client ?? http.Client();

  Uri getFullUrl([String subdir, Map<String, String> arguments]) {
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

    var result =
        await _httpClient.post(url, body: jsonEncode(body), headers: headers);

    if (result.statusCode == 200) {
      return ApiResultModel(
        code: result.statusCode,
        data: jsonDecode(result.body),
        hasError: false,
      );
    } else {
      return ApiResultModel(
        code: result.statusCode,
        message: jsonDecode(result.body)['message'],
        hasError: true,
      );
    }
  }

  Future<ApiResultModel> login(String emailAddress, String password) async {
    var url = getFullUrl('login');
    var body = {'email': emailAddress, 'password': password};
    var headers = {'Content-Type': 'application/json'};

    var result =
        await _httpClient.post(url, body: jsonEncode(body), headers: headers);

    if (result.statusCode == 200) {
      return ApiResultModel(
        code: result.statusCode,
        data: jsonDecode(result.body),
        hasError: false,
      );
    } else {
      return ApiResultModel(
        code: result.statusCode,
        message: jsonDecode(result.body)['message'],
        hasError: true,
      );
    }
  }

  Future<ApiResultModel> forgotPassword(String emailAddress) async {
    var url = getFullUrl('forgotPassword');
    var body = {'email': emailAddress};
    var headers = {'Content-Type': 'application/json'};

    var result =
        await _httpClient.post(url, body: jsonEncode(body), headers: headers);

    if (result.statusCode == 200) {
      return ApiResultModel(
        code: result.statusCode,
        message: jsonDecode(result.body)['message'],
        hasError: false,
      );
    } else {
      return ApiResultModel(
        code: result.statusCode,
        message: jsonDecode(result.body)['message'],
        hasError: true,
      );
    }
  }

  // void resetPassword() async {}

  /* User Functions */
  // void getUserData() async {}
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

    var result = await _httpClient.get(url, headers: headers);

    if (result.statusCode == 200) {
      return ApiResultModel(
        code: result.statusCode,
        data: jsonDecode(result.body),
        hasError: false,
      );
    } else {
      return ApiResultModel(
        code: result.statusCode,
        message: jsonDecode(result.body)['message'],
        hasError: true,
      );
    }
  }

  /* Hospital Functions */
  Future<ApiResultModel> getHospitals(String token) async {
    var url = getFullUrl('hospitals');
    var headers = {'Authorization': 'Bearer $token'};

    var result = await _httpClient.get(url, headers: headers);

    if (result.statusCode == 200) {
      return ApiResultModel(
        code: result.statusCode,
        data: jsonDecode(result.body),
        hasError: false,
      );
    } else {
      return ApiResultModel(
        code: result.statusCode,
        message: jsonDecode(result.body)['message'],
        hasError: true,
      );
    }
  }

  /* Appointment Functions */
  Future<ApiResultModel> getAppointments(String token) async {
    var url = getFullUrl('appointments');
    var headers = {'Authorization': 'Bearer $token'};

    var result = await _httpClient.get(url, headers: headers);

    if (result.statusCode == 200) {
      return ApiResultModel(
        code: result.statusCode,
        data: jsonDecode(result.body),
        hasError: false,
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
