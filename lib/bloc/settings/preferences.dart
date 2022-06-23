// shared_prefs.dart
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static late SharedPreferences _sharedPrefs;

  factory SharedPrefs() => SharedPrefs._internal();

  SharedPrefs._internal();

  Future<void> init() async {
    _sharedPrefs = await SharedPreferences.getInstance();
  }

  int? get getThemeIndex => _sharedPrefs.getInt(selectedThemeIndex);

  set setThemeIndex(int? value) {
    _sharedPrefs.setInt(selectedThemeIndex, value!);  // Using selectedThemeIndex from constant
  }
}

// constants.dart
const String selectedThemeIndex = "selected_theme_index";