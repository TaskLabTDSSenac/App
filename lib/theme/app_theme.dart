import 'package:flutter/material.dart';

class AppTheme {
  // Dark, high-contrast palette inspired by Jujutsu Kaisen.
  static const night = Color(0xff111116);
  static const gold = Color(0xffe83d55);
  static const paper = Color(0xfff2eee9);
  static const surfaceDark = Color(0xff202027);
  static const ink = Color(0xff111116);

  static ThemeData get theme {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: 'TaskLabText',
      colorScheme: ColorScheme.fromSeed(
        brightness: Brightness.dark,
        seedColor: gold,
        primary: gold,
        secondary: const Color(0xff8d62b5),
        surface: surfaceDark,
        error: const Color(0xffff6b6b),
      ),
    );
    return base.copyWith(
      scaffoldBackgroundColor: night,
      appBarTheme: const AppBarTheme(
        backgroundColor: night,
        foregroundColor: paper,
        surfaceTintColor: Colors.transparent,
      ),
      textTheme: base.textTheme.copyWith(
        headlineSmall: const TextStyle(
          fontFamily: 'TaskLabTitle',
          fontSize: 27,
          color: paper,
        ),
        titleLarge: const TextStyle(
          fontFamily: 'TaskLabTitle',
          fontSize: 23,
          color: paper,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xff49434b)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: gold, width: 2),
        ),
        filled: true,
        fillColor: surfaceDark,
        labelStyle: const TextStyle(color: paper),
        hintStyle: TextStyle(color: paper.withOpacity(.6)),
      ),
      cardTheme: CardThemeData(
        color: surfaceDark,
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: Color(0xff49303b)),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: gold,
          foregroundColor: Colors.white,
          minimumSize: const Size(48, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surfaceDark,
        indicatorColor: const Color(0xff49303b),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            color: states.contains(WidgetState.selected)
                ? gold
                : paper.withOpacity(.68),
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w700
                : FontWeight.normal,
          ),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: gold,
        foregroundColor: Colors.white,
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: surfaceDark,
        contentTextStyle: TextStyle(color: paper),
      ),
    );
  }
}
