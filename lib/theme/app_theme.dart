import 'package:flutter/material.dart';

class AppTheme {
  static const night = Color(0xff10151d);
  static const gold = Color(0xffffc857);
  static const paper = Color(0xfff4f1e9);
  static const pink = Color(0xfff2768b);
  static const cyan = Color(0xff6edbd2);
  static ThemeData get theme {
    final base = ThemeData(useMaterial3: true, fontFamily: 'TaskLabText', brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(seedColor: gold, brightness: Brightness.dark, surface: const Color(0xff1b222c)));
    return base.copyWith(
      scaffoldBackgroundColor: Colors.transparent,
      appBarTheme: const AppBarTheme(backgroundColor: Colors.transparent, foregroundColor: paper, centerTitle: false, elevation: 0),
      textTheme: base.textTheme.copyWith(
        headlineSmall: const TextStyle(fontFamily: 'TaskLabTitle', fontSize: 27, color: paper),
        titleLarge: const TextStyle(fontFamily: 'TaskLabTitle', fontSize: 20, color: paper),
        bodyMedium: const TextStyle(color: Color(0xffd1d5d9), height: 1.45)),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xff39424d))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: gold, width: 1.5)),
        filled: true, fillColor: const Color(0xff1b222c), labelStyle: const TextStyle(color: Color(0xffb5bbc3))),
      cardTheme: CardThemeData(color: const Color(0xff1b222c), margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: Color(0xff303a46)))),
      navigationBarTheme: NavigationBarThemeData(backgroundColor: const Color(0xff171d26), indicatorColor: gold.withValues(alpha: .18),
        labelTextStyle: WidgetStateProperty.resolveWith((states) => TextStyle(
          color: states.contains(WidgetState.selected) ? gold : const Color(0xffaeb5bd), fontWeight: FontWeight.w700))),
      filledButtonTheme: FilledButtonThemeData(style: FilledButton.styleFrom(backgroundColor: gold, foregroundColor: const Color(0xff211b12),
        minimumSize: const Size(48, 48), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontWeight: FontWeight.w800))),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(backgroundColor: gold, foregroundColor: night),
      chipTheme: base.chipTheme.copyWith(backgroundColor: const Color(0xff29333e),
        labelStyle: const TextStyle(color: paper, fontWeight: FontWeight.w700), side: BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
    );
  }
}
