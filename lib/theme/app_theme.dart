import 'package:flutter/material.dart';

class AppTheme {
  static const graphite = Color(0xff111416);
  static const panel = Color(0xfff4f5f1);
  static const accent = Color(0xffd9ff43);
  static const ink = Color(0xff1b2022);
  static const muted = Color(0xff737a7d);

  static ThemeData get theme {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: 'TaskLabText',
      colorScheme: ColorScheme.fromSeed(
        seedColor: accent,
        brightness: Brightness.dark,
        primary: accent,
        onPrimary: ink,
        surface: panel,
        onSurface: ink,
      ),
    );

    return base.copyWith(
      scaffoldBackgroundColor: graphite,
      appBarTheme: const AppBarTheme(
        backgroundColor: graphite,
        foregroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        toolbarHeight: 68,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          letterSpacing: .2,
          fontFamily: 'TaskLabText',
        ),
        iconTheme: IconThemeData(color: accent),
      ),
      textTheme: base.textTheme.copyWith(
        bodyLarge: const TextStyle(color: ink, fontSize: 16, height: 1.45),
        bodyMedium: const TextStyle(color: ink, fontSize: 14, height: 1.45),
        bodySmall: const TextStyle(color: muted, fontSize: 12, height: 1.4),
        labelLarge: const TextStyle(
          color: ink,
          fontWeight: FontWeight.w700,
          fontSize: 14,
        ),
        headlineSmall: const TextStyle(
          fontFamily: 'TaskLabText',
          fontWeight: FontWeight.w800,
          fontSize: 25,
          height: 1.15,
          color: ink,
        ),
        titleLarge: const TextStyle(
          fontFamily: 'TaskLabText',
          fontWeight: FontWeight.w700,
          fontSize: 19,
          height: 1.2,
          color: ink,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xffd7dbd5)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xffd7dbd5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: graphite, width: 1.6),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xffbd443d)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xffbd443d), width: 1.6),
        ),
        filled: true,
        fillColor: Colors.white,
        labelStyle: const TextStyle(color: muted),
        floatingLabelStyle: const TextStyle(color: graphite),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 17,
        ),
      ),
      cardTheme: CardThemeData(
        color: panel,
        elevation: 0,
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: const BorderSide(color: Color(0xffdce0da)),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: ink,
          disabledBackgroundColor: const Color(0xffbacb76),
          disabledForegroundColor: ink.withValues(alpha: .6),
          minimumSize: const Size(48, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: const Color(0xff252c2f),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xff252c2f),
          side: const BorderSide(color: Color(0xffaeb5b0)),
          minimumSize: const Size(48, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: const Color(0xff191e20),
        indicatorColor: accent,
        height: 74,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            color: selected ? accent : Colors.white70,
            fontSize: 12,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected ? ink : Colors.white70,
            size: 22,
          );
        }),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: accent,
        foregroundColor: ink,
        elevation: 4,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: const Color(0xff242a2d),
        contentTextStyle: const TextStyle(color: Colors.white),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xffdce0da),
        thickness: 1,
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: const Color(0xffe5e9e1),
        labelStyle: const TextStyle(
          color: Color(0xff303638),
          fontWeight: FontWeight.w700,
        ),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
    );
  }
}
