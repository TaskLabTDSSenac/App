import 'package:flutter/material.dart';

class AppTheme {
  static const night = Color(0xff090909);
  static const gold = Color(0xffffd500);
  static const paper = Color(0xff171717);
  static ThemeData get theme {
    final base = ThemeData(
      useMaterial3: true,
      fontFamily: 'TaskLabText',
      colorScheme: ColorScheme.fromSeed(
        brightness: Brightness.dark,
        seedColor: gold,
        surface: paper,
        onSurface: const Color(0xfff5f5f5),
      ),
    );
    return base.copyWith(
      scaffoldBackgroundColor: night,
      appBarTheme: const AppBarTheme(
        backgroundColor: night,
        foregroundColor: gold,
      ),
      textTheme: base.textTheme.copyWith(
        headlineSmall: const TextStyle(
          fontFamily: 'TaskLabTitle',
          fontSize: 27,
          color: Color(0xffffd500),
        ),
        titleLarge: const TextStyle(
          fontFamily: 'TaskLabTitle',
          fontSize: 23,
          color: Color(0xffffd500),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Color(0xff202020),
      ),
      cardTheme: CardThemeData(
        color: paper,
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: gold),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
        backgroundColor: gold,
        foregroundColor: const Color(0xff111111),
          minimumSize: const Size(48, 48),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: gold,
        foregroundColor: night,
      ),
    );
  }
}
