import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static Future<void> savString({String? key, String? value}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(key!, value!);
  }

  static Future<String> getString(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(key) ?? '';
  }

  static void clearLocalStorage() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();
  }

  static Future<void> saveBool({String? key, bool? value}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool(key!, value!);
  }

  static Future<bool> getBool(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool(key) ?? false;
  }
}
