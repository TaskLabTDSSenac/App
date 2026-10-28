import 'package:flutter/material.dart';

class AppTheme {
  static const night = Color(0xff090909);
  static const gold = Color(0xffe36550);
  static const paper = Color(0xff1b1b1b);
  static const chrome = Color(0xffeee8df);

  static ThemeData get theme {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: 'TaskLabText',
      colorScheme: const ColorScheme.dark(
        primary: gold,
        onPrimary: Color(0xff190a07),
        secondary: Color(0xffc7b9a7),
        surface: paper,
        onSurface: chrome,
        error: Color(0xffffb4a8),
        outline: Color(0xff65554e),
      ),
    );
    const shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(5)),
      side: BorderSide(color: Color(0xff493b35)),
    );
    return base.copyWith(
      scaffoldBackgroundColor: night,
      appBarTheme: const AppBarTheme(
        backgroundColor: night,
        foregroundColor: chrome,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          fontFamily: 'TaskLabText',
          fontWeight: FontWeight.w700,
          fontSize: 20,
          letterSpacing: 1.2,
          color: chrome,
        ),
      ),
      textTheme: base.textTheme.copyWith(
        headlineSmall: const TextStyle(
          fontFamily: 'TaskLabText',
          fontWeight: FontWeight.w700,
          fontSize: 27,
          letterSpacing: 1,
          color: chrome,
        ),
        titleLarge: const TextStyle(
          fontFamily: 'TaskLabText',
          fontWeight: FontWeight.w700,
          fontSize: 23,
          color: chrome,
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xff5b514b)),
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: gold, width: 2),
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        filled: true,
        fillColor: Color(0xff101010),
      ),
      cardTheme: const CardThemeData(
        color: paper,
        surfaceTintColor: Colors.transparent,
        margin: EdgeInsets.symmetric(vertical: 8),
        shape: shape,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xffb9392c),
          foregroundColor: Colors.white,
          minimumSize: const Size(48, 48),
          textStyle: const TextStyle(
            fontFamily: 'TaskLabText',
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xffb9392c),
        foregroundColor: Colors.white,
        shape: shape,
      ),
      navigationBarTheme: const NavigationBarThemeData(
        backgroundColor: Color(0xff141414),
        indicatorColor: Color(0xff602c24),
        surfaceTintColor: Colors.transparent,
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: const Color(0xff302622),
        side: const BorderSide(color: Color(0xff715044)),
      ),
      dialogTheme: const DialogThemeData(backgroundColor: paper, shape: shape),
      dividerTheme: const DividerThemeData(color: Color(0xff453b36)),
    );
  }
}
