import 'package:flutter/material.dart';

class AppTheme {
  static const night = Color(0xff091321);
  static const gold = Color(0xffc8a567);
  static const paper = Color(0xfff3e8d1);
  static ThemeData get theme {
    final base = ThemeData(
      useMaterial3: true,
      fontFamily: 'TaskLabText',
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xff795a29),
        surface: paper,
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
          color: Color(0xff302b25),
        ),
        titleLarge: const TextStyle(
          fontFamily: 'TaskLabTitle',
          fontSize: 23,
          color: Color(0xff302b25),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Color(0xfffffaf0),
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
          foregroundColor: const Color(0xff2d2415),
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
