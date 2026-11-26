import 'package:flutter/material.dart';

enum AppFontStyle {
  legible(
    label: 'Leitura confortável',
    bodyFamily: 'TaskLabText',
    headingFamily: 'TaskLabTitle',
  ),
  manuscript(
    label: 'Manuscrito',
    bodyFamily: 'TaskLabTitle',
    headingFamily: 'TaskLabTitle',
  );

  final String label;
  final String bodyFamily;
  final String headingFamily;

  const AppFontStyle({
    required this.label,
    required this.bodyFamily,
    required this.headingFamily,
  });
}

class AppTheme {
  static const night = Color(0xff1b0b12);
  static const forest = Color(0xff481827);
  static const gold = Color(0xffc7a04b);
  static const brightGold = Color(0xffefd181);
  static const paper = Color(0xfff4e8d1);
  static const ink = Color(0xff30251f);
  static const mutedInk = Color(0xff716052);

  static ThemeData theme({AppFontStyle fontStyle = AppFontStyle.legible}) {
    final scheme = ColorScheme.fromSeed(
      seedColor: forest,
      brightness: Brightness.dark,
      primary: gold,
      onPrimary: night,
      secondary: const Color(0xff9a5366),
      surface: paper,
      onSurface: ink,
      error: const Color(0xffb45345),
    );
    final base = ThemeData(
      useMaterial3: true,
      fontFamily: fontStyle.bodyFamily,
      colorScheme: scheme,
    );

    return base.copyWith(
      scaffoldBackgroundColor: night,
      appBarTheme: AppBarTheme(
        backgroundColor: night,
        foregroundColor: brightGold,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: TextStyle(
          fontFamily: fontStyle.headingFamily,
          fontSize: 20,
          color: brightGold,
        ),
      ),
      textTheme: base.textTheme.copyWith(
        headlineSmall: TextStyle(
          fontFamily: fontStyle.headingFamily,
          fontSize: 27,
          height: 1.25,
          color: ink,
        ),
        titleLarge: TextStyle(
          fontFamily: fontStyle.headingFamily,
          fontSize: 23,
          color: ink,
        ),
        titleMedium: TextStyle(
          fontFamily: fontStyle.headingFamily,
          fontSize: 17,
          color: ink,
        ),
        bodyLarge: TextStyle(
          fontFamily: fontStyle.bodyFamily,
          color: ink,
          height: 1.45,
        ),
        bodyMedium: TextStyle(
          fontFamily: fontStyle.bodyFamily,
          color: ink,
          height: 1.4,
        ),
        bodySmall: TextStyle(fontFamily: fontStyle.bodyFamily, color: mutedInk),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xfffff9ed),
        labelStyle: TextStyle(
          fontFamily: fontStyle.bodyFamily,
          color: mutedInk,
        ),
        hintStyle: TextStyle(
          fontFamily: fontStyle.bodyFamily,
          color: mutedInk.withValues(alpha: 0.75),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
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
          borderSide: const BorderSide(color: gold, width: 2),
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: brightGold,
          side: const BorderSide(color: gold),
          minimumSize: const Size(48, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: forest),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: forest,
        indicatorColor: gold.withValues(alpha: 0.22),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            color: states.contains(WidgetState.selected)
                ? brightGold
                : paper.withValues(alpha: 0.7),
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w700
                : FontWeight.w400,
          ),
        ),
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            color: states.contains(WidgetState.selected)
                ? brightGold
                : paper.withValues(alpha: 0.7),
          ),
        ),
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
