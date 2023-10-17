import 'package:flutter/material.dart';

class ThemeManager {
  ThemeManager._();

  static ThemeData get themeDev => ThemeData(
        primaryColor: const Color(0xFF06789A),
        scaffoldBackgroundColor: const Color(0xFFF0F0F0),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: Color(0xFF071F05),
          unselectedItemColor: Color(0xFF071F05),
        ),
        primarySwatch: Colors.red,
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF06789A),
          secondary: Color(0xFF025B76),
          secondaryContainer: Color(0xFFE1E1E1),
          background: Color(0xFFE1E1E1),
          inversePrimary: Color(0xFFE7E0CA),
          outline: Color(0xFF979797),
          tertiary: Color(0xFFe7e0ca),
        ),
      );

  static ThemeData get themeProd => ThemeData(
        primaryColor: const Color(0xFF06789A),
        scaffoldBackgroundColor: const Color(0xFFF0F0F0),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: Color(0xFF071F05),
          unselectedItemColor: Color(0xFF071F05),
        ),
        primarySwatch: Colors.red,
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF06789A),
          secondary: Color(0xFF025B76),
          secondaryContainer: Color(0xFFE1E1E1),
          background: Color(0xFFE1E1E1),
          inversePrimary: Color(0xFFE7E0CA),
          outline: Color(0xFF979797),
          tertiary: Color(0xFFe7e0ca),
        ),
      );
}
