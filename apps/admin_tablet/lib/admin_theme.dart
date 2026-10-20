import 'package:flutter/material.dart';

abstract final class AdminTheme {
  static const ink = Color(0xFF173B3A);
  static const teal = Color(0xFF176B63);
  static const tealLight = Color(0xFFE2F1ED);
  static const copper = Color(0xFFC76C43);
  static const paper = Color(0xFFF4F6F2);
  static const line = Color(0xFFD8E0DC);

  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: teal,
      primary: teal,
      secondary: copper,
      surface: Colors.white,
      error: const Color(0xFFB33A3A),
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: paper,
      appBarTheme: const AppBarTheme(
        backgroundColor: paper,
        foregroundColor: ink,
        elevation: 0,
      ),
      navigationRailTheme: const NavigationRailThemeData(
        backgroundColor: Colors.white,
        selectedIconTheme: IconThemeData(color: teal),
        unselectedIconTheme: IconThemeData(color: Color(0xFF667975)),
        selectedLabelTextStyle: TextStyle(
          color: teal,
          fontWeight: FontWeight.w700,
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: line),
        ),
      ),
      dividerTheme: const DividerThemeData(color: line, thickness: 1),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: line),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: line),
        ),
      ),
    );
  }
}