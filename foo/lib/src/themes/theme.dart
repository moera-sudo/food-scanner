import 'package:flutter/material.dart';


class AppTheme {
  static final ThemeData light = ThemeData(   // Light theme won't be used for a while
    brightness: Brightness.light,
    primaryColor: const Color(0xFFEF8235), // акцент — оранжевый
    scaffoldBackgroundColor: const Color(0xFFF5F5F5),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFF5F5F5),
      foregroundColor: Color(0xFF1C1C1C),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1C1C1C),
      ),
      bodyMedium: TextStyle(
        fontSize: 16,
        color: Color(0xFF2E2E2E),
      ),
    ),
  );

  static final ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    primaryColor:  Color(0xFFEF8235), // оранжевый акцент кнопок
    scaffoldBackgroundColor:  Color(0xFF1C1C1C), // фон экранов
    cardColor: Color(0xFF2A2A2A), // карточки, табы 
    appBarTheme:  AppBarTheme(
      backgroundColor: Color(0xFF1C1C1C),
      foregroundColor: Colors.white,
    ),
    textTheme:  TextTheme(
      headlineLarge: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      bodyMedium: TextStyle(
        fontSize: 16,
        color: Color(0xFFE0E0E0),
      ),
      labelLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Color(0xFFEF8235), // для кнопок/ссылок
      ),
    ),
    bottomNavigationBarTheme:  BottomNavigationBarThemeData(
      backgroundColor: Color.fromARGB(255, 52, 51, 51),
      selectedItemColor: Color(0xFFEF8235),
      unselectedItemColor: Color(0xFF8C8C8C),
    ),
  );
}
