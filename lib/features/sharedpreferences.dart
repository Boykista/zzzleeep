import 'package:shared_preferences/shared_preferences.dart';

class SimplePreferences {
  static late SharedPreferences _preferences;

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setCounter({int? counter}) async {
    await _preferences.setInt('counter', counter!);
  }

  static int getCounter() => _preferences.getInt('counter') ?? 0;

  static Future lastDate({String? lastDate}) async {
    await _preferences.setString('lastDate', lastDate!);
  }

  static String getLastDate() => _preferences.getString('lastDate')!;
}
