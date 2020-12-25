import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  SharedPreferencesService._privateConstructor();
  static final SharedPreferencesService _instance =
      SharedPreferencesService._privateConstructor();

  SharedPreferences _sharedPreferences;

  factory SharedPreferencesService() {
    return _instance;
  }
  Future<SharedPreferences> get sharedPreferences async {
    if (_sharedPreferences == null) {
      _sharedPreferences = await SharedPreferences.getInstance();
    }
    return _sharedPreferences;
  }

  Future<bool> get firstRun async {
    return (await sharedPreferences).getBool("welcome") == null;
  }

  Future<void> setKeyValue(String key, dynamic value) async {
    if (value is bool) {
      (await sharedPreferences).setBool(key, value);
    } else if (value is String) {
      (await sharedPreferences).setString(key, value);
    } else if (value is double) {
      (await sharedPreferences).setDouble(key, value);
    } else if (value is int) {
      (await sharedPreferences).setInt(key, value);
    }
  }
}
