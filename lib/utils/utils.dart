import 'package:shared_preferences/shared_preferences.dart';

class Utils {
  // 0 : dart
  // 1 : light
  static const String _PREF_THEME = "app_theme";
     Future<void> saveTheme(int themeIndex) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(_PREF_THEME, themeIndex);
  }

   Future<int> getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_PREF_THEME) ?? 0;
  }
}
