import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  static const String _themeKey = 'isDarkMode';

  bool get isDarkMode => _isDarkMode;

  ThemeProvider() {
    _loadThemePreference();
  }

  void _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool(_themeKey) ?? false;
    notifyListeners();
  }

  void toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, _isDarkMode);
    notifyListeners();
  }

  ThemeData get themeData => _isDarkMode ? darkTheme : lightTheme;

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF0B0E11),
      foregroundColor: Colors.white,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF0B0E11),
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white70,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: const Color(0xFF161617),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF222629),
      foregroundColor: Colors.white,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF222629),
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white70,
    ),
  );

  Color get backgroundColor =>
      _isDarkMode ? const Color(0xFF161617) : Colors.white;
  Color get cardColor => _isDarkMode ? const Color(0xFF222629) : const Color(0xFFf7fcfc);
  Color get textColor => _isDarkMode ? Colors.white : Colors.black;
  Color get subtitleColor =>
      _isDarkMode ? Colors.grey[400]! : const Color(0xFF777777);
  Color get listItemColor =>
      _isDarkMode ? const Color(0xFF222629) : const Color(0xFFE7F2F3);
  Color get searchBarColor =>
      _isDarkMode ? const Color(0xFF4c4e54) : const Color(0xFF191E25);
  Color get headerColor =>
      _isDarkMode ? const Color(0xFF58b8c7) : const Color(0xFF1E91A3);
  Color get barColor =>
      _isDarkMode ? const Color(0xFF222629) : const Color(0xFF0B0E11);
  Color get dividerColor => _isDarkMode ? Colors.grey[800]! : Colors.grey[300]!;
  Color get iconBgColor => _isDarkMode
      ? const Color.fromARGB(255, 11, 36, 37)
      : const Color(0xFFC2E4E7);
  Color get draggableSheetColor =>
      _isDarkMode ? const Color(0xFF222629) : Colors.white;
  Color get draggableSheetTextColor =>
      _isDarkMode ? Colors.white : Colors.black;
  Color get expandedCardColor =>
      _isDarkMode ? const Color(0xFF2C2F33) : Colors.white;
  Color get selectedItemBgColor =>
      _isDarkMode ? const Color(0xFF4c4e54) : const Color(0xFFE3F2FD);
  Color get hintTextColor => _isDarkMode
      ? Colors.white.withOpacity(0.35)
      : Colors.white.withOpacity(0.35);
  Color get cyanBgColor => _isDarkMode
      ? const Color.fromARGB(255, 34, 48, 49)
      : const Color(0xFFE7F2F3);
}
