import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:http/http.dart' as http;

/* Project-level Imports */
// Data Models
import '../models/api_result.dart';

class ByteCareAPI {
  static ByteCareAPI _instance;

  static const String namespace = 'api';

  factory ByteCareAPI([Uri hostUri, http.Client client]) {
    if (_instance == null) {
      _instance = ByteCareAPI._internal(hostUri, client);
    }

    return _instance;
  }

  // Constants
  final Map<String, Uri> routes = {
    'signup': Uri(pathSegments: [namespace, 'auth', 'signup']),
    'login': Uri(pathSegments: [namespace, 'auth', 'login']),
    'appointment': Uri(pathSegments: [namespace, 'appointment']),
    'appointments': Uri(pathSegments: [namespace, 'appointments']),
    'hospitals': Uri(pathSegments: [namespace, 'hospitals']),
  };

  // Instance Variables
  Uri _hostUri;
  http.Client _httpClient;

  String _authToken;

  // Instance Constructor
  ByteCareAPI._internal(Uri host, [http.Client client]) {
    _httpClient = client ?? http.Client();
    this._hostUri = host;
  }

  // Getters and Setters
  Uri getFullUrl([String subdir]) {
    if (subdir == null || subdir.isEmpty) {
      return _hostUri;
    }

    if (!routes.containsKey(subdir)) {
      throw ArgumentError('The key `$subdir` does not exist in the routes.');
    }

    return _hostUri.resolveUri(routes[subdir]);
  }

  String get authToken => _authToken;

  set authToken(String token) {
    if (_authToken == null) {
      _authToken = token;
    }
  }

  Future<bool> testConnection() async {
    var resp = await _httpClient.head(getFullUrl());

    if (resp.statusCode == 500) {
      return false;
    }

    return true;
  }

  // Authorisation `auth` Functions
  Future<ApiResult> signup({
    @required String emailAddress,
    @required password,
  }) async {
    var url = getFullUrl('signup');
    var body = {
      'email': emailAddress,
      'password': password,
    };
    var headers = {
      'Content-Type': 'application/json',
    };

    var result = await _httpClient.post(
      url,
      body: jsonEncode(body),
      headers: headers,
    );

    if (result.statusCode == 200) {
      return ApiResult(
        code: 200,
        hasError: false,
      );
    } else {
      return ApiResult(
        code: result.statusCode,
        hasError: true,
        message: result.body,
      );
    }
  }

  Future<ApiResult> login({
    @required String emailAddress,
    @required password,
  }) async {
    var url = getFullUrl('login');
    var body = {
      'email': emailAddress,
      'password': password,
    };
    var headers = {
      'Content-Type': 'application/json',
    };

    var result = await _httpClient.post(
      url,
      body: jsonEncode(body),
      headers: headers,
    );

    if (result.statusCode == 200) {
      var data = jsonDecode(result.body);

      _authToken = data['token'];
      // Waiting for backend to implement.
      // _userId = data['userid'];
      // _email = data['email'];

      return ApiResult(
        code: 200,
      );
    } else {
      return ApiResult(
        code: result.statusCode,
        hasError: true,
        message: result.body,
      );
    }
  }

  void forgotPassword() {}

  void resetPassword() {}

// User Functions
  void getUserData() {}

  void updateUserData() {}

  void deleteUser() {}

// User Address Functions
  void getUserAddresses() {}

  void addUserAddress() {}

  void updateUserAddress() {}

  void removeUserAddress() {}

// User Contact Functions
  void getUserContacts() {}

// Hospital Functions
  Future<ApiResult> getClinics() async {
    var url = getFullUrl('hospitals');
    var headers = {'Authorization': 'Bearer $_authToken}'};

    var result = await _httpClient.get(url, headers: headers);

    if (result.statusCode == 200) {
      var data = jsonDecode(result.body);

      return ApiResult(
        code: result.statusCode,
        hasError: false,
        data: data,
      );
    } else {
      return ApiResult(
        code: result.statusCode,
        hasError: true,
      );
    }
  }

  // Appointment Functions
  Future<ApiResult> getAppointments() async {
    var url = getFullUrl('appointments');
    var headers = {'Authorization': 'Bearer $_authToken}'};

    var result = await _httpClient.get(url, headers: headers);

    if (result.statusCode == 200) {
      print('power');
      var data = jsonDecode(result.body);
      print('Appointment Data: $data}');

      return ApiResult(
        code: result.statusCode,
        hasError: false,
        data: data,
      );
    } else {
      return ApiResult(
        code: result.statusCode,
        hasError: true,
        message: 'Failed to load Appointments',
        data: result.body,
      );
    }
  }

  void logout() {
    _authToken = null;
  }
}
