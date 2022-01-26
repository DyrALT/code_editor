import 'package:shared_preferences/shared_preferences.dart';
import 'package:note_code/models/languages.dart';

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

  // mode language

  getLangugage(String key) {
    switch (key) {
      case "py":
        {
          return python;
        }
      case "js":
        {
          return javascript;
        }
      case "c":
        {
          return cpp;
        }
      case "csharp":
        {
          return cs;
        }

      case "jsp":
        {
          return java;
        }
      case "sh":
        {
          return bash;
        }

      case "kt":
        {
          return kotlin;
        }

      case "pl":
        {
          return perl;
        }
      case "golang":
        {
          return go;
        }
      case "php":
        {
          return php;
        }
      case "rb":
        {
          return ruby;
        }
      case "html":
        {
          return xml;
        }

      case "mm":
        {
          return objectivec;
        }

      case "rs":
        {
          return rust;
        }
      case "dart":
        {
          return dart;
        }
      case "arduino":
        {
          return arduino;
        }
      case "swift":
        {
          return swift;
        }
      case "gradle":
        {
          return gradle;
        }
      case "sql":
        {
          return sql;
        }
      case "json":
        {
          return json;
        }
      case "css":
        {
          return css;
        }
    }
  }

  String setLangugage(var x) {
    try {
      var dil = x.aliases[0];
      return dil;
    } catch (e) {
      if (x == dart) {
        return "dart";
      }
      if (x == arduino) {
        return "arduino";
      }
      if (x == swift) {
        return "swift";
      }
      if (x == gradle) {
        return "gradle";
      }
      if (x == sql) {
        return "sql";
      }
      if (x == json) {
        return "json";
      }
      if (x == css) {
        return "css";
      } else {
        return "null";
      }
    }
  }
}
