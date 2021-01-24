import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthStorage {
  static AuthStorage _instance;

  static AuthStorage getInstance() => _instance;

  static void init([String authToken]) {
    _instance = AuthStorage._(authToken);
  }

  FlutterSecureStorage _storage;
  String _loginTokenKey;

  AuthStorage._([String authToken])
      : assert(authToken != null ? authToken.isNotEmpty : true),
        _storage = FlutterSecureStorage(),
        _loginTokenKey = authToken ?? 'login_token';

  Future<bool> get hasLoginToken async {
    return await _storage.containsKey(key: _loginTokenKey);
  }

  Future<String> retrieveLoginToken() async {
    return await _storage.read(key: _loginTokenKey);
  }

  void storeLoginToken(String token) {
    assert(token != null);
    assert(token.isNotEmpty);
    _storage.write(key: _loginTokenKey, value: token);
  }

  void removeLoginToken() {
    _storage.delete(key: _loginTokenKey);
  }
}
