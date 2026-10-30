import 'package:flutter/material.dart';

class AppTheme {
  static const night = Color(0xff0b0d10);
  static const gold = Color(0xffe10600);
  static const paper = Color(0xff191d22);
  static const steel = Color(0xff9da7b1);

  static ThemeData get theme {
    final scheme = ColorScheme.fromSeed(
      seedColor: gold,
      brightness: Brightness.dark,
      surface: paper,
      primary: gold,
      secondary: steel,
    );
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: 'TaskLabText',
      colorScheme: scheme,
    );
    return base.copyWith(
      scaffoldBackgroundColor: night,
      appBarTheme: const AppBarTheme(
        backgroundColor: night,
        foregroundColor: Colors.white,
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      textTheme: base.textTheme.copyWith(
        headlineSmall: const TextStyle(
          fontFamily: 'TaskLabTitle', fontSize: 27, color: Colors.white,
        ),
        titleLarge: const TextStyle(
          fontFamily: 'TaskLabTitle', fontSize: 21, color: Colors.white,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: const Color(0xff171b20),
        labelStyle: const TextStyle(color: steel),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: Color(0xff353c44)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: gold, width: 1.5),
        ),
      ),
      cardTheme: CardThemeData(
        color: paper,
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xff30363d)),
        ),
      ),
      navigationBarTheme: const NavigationBarThemeData(
        backgroundColor: Color(0xff121519),
        indicatorColor: Color(0xff421916),
        labelTextStyle: WidgetStatePropertyAll(TextStyle(color: Colors.white70)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: gold,
          foregroundColor: Colors.white,
          minimumSize: const Size(48, 48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: gold,
        foregroundColor: Colors.white,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(color: gold),
      dividerColor: const Color(0xff30363d),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: const Color(0xff252b31),
        side: const BorderSide(color: Color(0xff3b434b)),
        labelStyle: const TextStyle(color: Colors.white70),
      ),
    );
  }
}
