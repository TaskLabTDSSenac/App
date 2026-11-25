import 'package:flutter/material.dart';

class AppTheme {
  static const night = Color(0xff101114);
  static const gold = Color(0xffd4b35f);
  static const red = Color(0xffb52f3b);
  static const paper = Color(0xfff3eee5);
  static const surfaceDark = Color(0xff1b1c20);
  static const border = Color(0xff39383b);

  static ThemeData get theme {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: 'TaskLabText',
      colorScheme: ColorScheme.fromSeed(
        brightness: Brightness.dark,
        seedColor: red,
        primary: red,
        secondary: gold,
        surface: surfaceDark,
        error: const Color(0xffff8585),
      ),
    );
    final outline = OutlineInputBorder(
      borderRadius: BorderRadius.circular(13),
      borderSide: const BorderSide(color: border),
    );
    return base.copyWith(
      scaffoldBackgroundColor: night,
      dividerColor: border,
      appBarTheme: const AppBarTheme(
        backgroundColor: night,
        foregroundColor: paper,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        elevation: 0,
      ),
      textTheme: base.textTheme.copyWith(
        headlineSmall: const TextStyle(
          fontFamily: 'TaskLabTitle',
          fontSize: 26,
          color: paper,
        ),
        titleLarge: const TextStyle(
          fontFamily: 'TaskLabTitle',
          fontSize: 21,
          color: paper,
        ),
        bodyMedium: TextStyle(color: paper.withValues(alpha: .88), height: 1.5),
      ),
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: outline,
        enabledBorder: outline,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(color: gold, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(color: Color(0xffff8585)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(color: Color(0xffff8585), width: 2),
        ),
        filled: true,
        fillColor: surfaceDark,
        labelStyle: const TextStyle(color: paper),
        hintStyle: TextStyle(color: paper.withValues(alpha: .56)),
      ),
      cardTheme: CardThemeData(
        color: surfaceDark,
        elevation: 0,
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: border),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: red,
          foregroundColor: Colors.white,
          disabledBackgroundColor: const Color(0xff514248),
          disabledForegroundColor: const Color(0xffc3b9b7),
          minimumSize: const Size(52, 52),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: gold,
          minimumSize: const Size(48, 48),
          side: const BorderSide(color: Color(0xff62513a)),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: gold,
          minimumSize: const Size(48, 48),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surfaceDark,
        indicatorColor: const Color(0xff45252a),
        height: 72,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            color: states.contains(WidgetState.selected)
                ? gold
                : paper.withValues(alpha: .68),
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w700
                : FontWeight.normal,
          ),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: red,
        foregroundColor: Colors.white,
        extendedTextStyle: TextStyle(fontWeight: FontWeight.w700),
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: surfaceDark,
        contentTextStyle: TextStyle(color: paper),
        behavior: SnackBarBehavior.floating,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(color: gold),
    );
  }
}
