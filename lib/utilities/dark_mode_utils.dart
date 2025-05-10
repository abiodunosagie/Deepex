import 'package:shared_preferences/shared_preferences.dart';

class DarkModeUtils {
  static const String _darkModeKey = 'dark_mode';

  // Set dark mode preference
  static Future<void> setDarkMode(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(_darkModeKey, isDarkMode);
  }

  // Get dark mode preference
  static Future<bool> getDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_darkModeKey) ?? false; // Default to light mode
  }
}
