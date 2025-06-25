import 'package:shared_preferences/shared_preferences.dart';

const String fistOpenApp = 'fistOpenApp1';
const String listUrl = 'listUrl';

class SharedPreferencesSingleton {
  static final _service = SharedPreferencesSingleton._internal();
  SharedPreferencesSingleton._internal();
  factory SharedPreferencesSingleton() => _service;
  late SharedPreferences _sharedPreferences;

  Future init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  Future save(String key, String value) async {
    await _sharedPreferences.setString(key, value);
  }

  String? get(String key) {
    return _sharedPreferences.getString(key);
  }

  Future remove(String key) async {
    await _sharedPreferences.remove(key);
  }

  Future saveListString(String key, List<String>? value) async {
    await _sharedPreferences.setStringList(key, value ?? []);
  }

  List<String>? getListString(String key) {
    var data = _sharedPreferences.getStringList(key);
    return data;
  }
}

final sharedPreferences = SharedPreferencesSingleton();
