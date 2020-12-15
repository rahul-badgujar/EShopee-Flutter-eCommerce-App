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
}
