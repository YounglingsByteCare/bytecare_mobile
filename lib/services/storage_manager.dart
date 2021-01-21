import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageManager {
  static StorageManager _instance;

  final List<Type> _prefsAllowedTypes = [String, int, bool, double, List];

  // const List<Type> _prefsAllowedTypes = [
  //
  // String
  //
  // ,
  //
  // Bool
  //
  // ,
  //
  // Int
  //
  // ,
  //
  // Double
  //
  // ,
  //
  // List<String>
  //
  // ];

  factory StorageManager() {
    if (_instance == null) {
      _instance = StorageManager._internal();
    }

    return _instance;
  }

  FlutterSecureStorage _storage;

  StorageManager._internal() {
    _storage = FlutterSecureStorage();
  }

  Future<bool> get hasLoginToken async {
    return await _storage.containsKey(key: 'login_token');
  }

  void storeLoginToken(String token) {
    _storage.write(key: 'login_token', value: token);
  }

  void removeLoginToken() {
    _storage.delete(key: 'login_token');
  }

  Future<String> retrieveLoginToken() async {
    return await _storage.read(key: 'login_token');
  }

  Future<bool> hasPrefsKey(String key) async {
    var _prefs = await SharedPreferences.getInstance();
    if (!_prefs.containsKey(key)) {
      return false;
    }
    return true;
  }

  void setPrefsValue<T>(String key, T value) async {
    assert(_prefsAllowedTypes.contains(T));

    var _prefs = await SharedPreferences.getInstance();

    if (T == String) {
      await _prefs.setString(key, value as String);
    } else if (T == int) {
      await _prefs.setInt(key, value as int);
    } else if (T == bool) {
      await _prefs.setBool(key, value as bool);
    } else if (T == double) {
      await _prefs.setDouble(key, value as double);
    }
  }

  Future<T> getPrefsValue<T>(String key) async {
    var _prefs = await SharedPreferences.getInstance();
    if (!_prefs.containsKey(key)) {
      throw ArgumentError('The specified key `$key` does not exist.');
    } else {
      return _prefs.get(key) as T;
    }
  }

  Future<Map<String, String>> get allOptions async => await _storage.readAll();
}
