import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/* Project-level Imports */
// Data Models
import '../models/api_result.dart';

class ByteCareAPI {
  // Constant Variables
  static final Map<String, Uri> routes = {
    'signup': Uri(pathSegments: ['api', 'auth', 'signup']),
    'login': Uri(pathSegments: ['api', 'auth', 'login']),
  };

  // Member Variables
  Uri hostUri;

  String user_token;
  String user_id;
  String username;
  String user_email;

  // Constructor
  ByteCareAPI(this.hostUri);

  // Static Variables
  static ByteCareAPI instance;

  // NOTE: Not sure if I need this yet, but it's if it becomes necessary.
  static void initInstance(Uri hostUri) {
    ByteCareAPI.instance = ByteCareAPI(hostUri);
  }

  // Authorisation Functions
  static Future<ApiResult> signup({
    @required String username,
    @required String phone,
    @required String emailAddress,
    @required String password,
  }) async {
    var route = ByteCareAPI.routes['signup'];
    var api = ByteCareAPI.instance.hostUri.resolveUri(route);

    http.post(api);

    await Future.delayed(Duration(seconds: 15));
    return ApiResult(code: 200, message: '');
  }

  static void login() {}

  static void forgotPassword() {}

  static void resetPassword() {}

  // User Functions
  static void getUserData() {}

  static void updateUserData() {}

  static void deleteUser() {}

  // User Address Functions
  static void getUserAddresses() {}

  static void addUserAddress() {}

  static void updateUserAddress() {}

  static void removeUserAddress() {}

  // User Contact Functions
  static void getUserContacts() {}
}
