import 'package:shared_preferences/shared_preferences.dart';

class Utils {
  // 0 : light
  // 1 : dart
  static const String _PREF_THEME = "app_theme";
  Future<void> saveTheme(int themeIndex) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(_PREF_THEME, themeIndex);
  }

  Future<String?> getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getInt(_PREF_THEME) == 0) {
      return "Açık";
    }
    if (prefs.getInt(_PREF_THEME) == 1) {
      return "Koyu";
    } else {
      return "Açık";
    }
  }

  Future<void> clearTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    print("TEMA SİLİNDİ");
  }
}
