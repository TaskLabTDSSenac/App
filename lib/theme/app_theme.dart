import 'package:flutter/material.dart';

class AppTheme {
  static const night = Color(0xff111812);
  static const forest = Color(0xff1b2920);
  static const gold = Color(0xffc7a56b);
  static const brightGold = Color(0xffe0c58f);
  static const paper = Color(0xfff1e6ce);
  static const ink = Color(0xff2d2a22);
  static const mutedInk = Color(0xff696354);

  static ThemeData get theme {
    final scheme = ColorScheme.fromSeed(
      seedColor: forest,
      brightness: Brightness.dark,
      primary: gold,
      onPrimary: night,
      secondary: const Color(0xff879b72),
      surface: paper,
      onSurface: ink,
      error: const Color(0xffb45345),
    );
    final base = ThemeData(
      useMaterial3: true,
      fontFamily: 'TaskLabText',
      colorScheme: scheme,
    );

    return base.copyWith(
      scaffoldBackgroundColor: night,
      appBarTheme: const AppBarTheme(
        backgroundColor: night,
        foregroundColor: brightGold,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: TextStyle(
          fontFamily: 'TaskLabTitle',
          fontSize: 20,
          color: brightGold,
        ),
      ),
      textTheme: base.textTheme.copyWith(
        headlineSmall: const TextStyle(
          fontFamily: 'TaskLabTitle',
          fontSize: 27,
          height: 1.25,
          color: ink,
        ),
        titleLarge: const TextStyle(
          fontFamily: 'TaskLabTitle',
          fontSize: 23,
          color: ink,
        ),
        titleMedium: const TextStyle(
          fontFamily: 'TaskLabTitle',
          fontSize: 17,
          color: ink,
        ),
        bodyLarge: const TextStyle(color: ink, height: 1.45),
        bodyMedium: const TextStyle(color: ink, height: 1.4),
        bodySmall: const TextStyle(color: mutedInk),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xfffff9ed),
        labelStyle: const TextStyle(color: mutedInk),
        hintStyle: TextStyle(color: mutedInk.withValues(alpha: 0.75)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xffc9b991)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xffc9b991)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: forest, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xffb45345)),
        ),
      ),
      cardTheme: CardThemeData(
        color: paper,
        elevation: 3,
        shadowColor: Colors.black.withValues(alpha: 0.28),
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: gold, width: 1.1),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: gold,
          foregroundColor: night,
          minimumSize: const Size(48, 50),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: forest,
          side: const BorderSide(color: forest),
          minimumSize: const Size(48, 48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: forest),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: forest,
        indicatorColor: gold.withValues(alpha: 0.22),
        labelTextStyle: WidgetStateProperty.resolveWith((states) => TextStyle(
          color: states.contains(WidgetState.selected) ? brightGold : paper.withValues(alpha: 0.7),
          fontWeight: states.contains(WidgetState.selected) ? FontWeight.w700 : FontWeight.w400,
        )),
        iconTheme: WidgetStateProperty.resolveWith((states) => IconThemeData(
          color: states.contains(WidgetState.selected) ? brightGold : paper.withValues(alpha: 0.7),
        )),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: gold,
        foregroundColor: night,
        elevation: 5,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: forest,
        contentTextStyle: const TextStyle(color: paper),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(color: gold),
      dividerTheme: const DividerThemeData(color: Color(0x55c7a56b)),
    );
  }
}
