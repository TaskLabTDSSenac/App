import 'package:flutter/material.dart';

class AppTheme {
  static const voidBlack = Color(0xff090a12);
  static const panel = Color(0xff151725);
  static const cyan = Color(0xff39f5e8);
  static const magenta = Color(0xffff3cac);
  static const text = Color(0xfff2f3ff);
  static const muted = Color(0xffa4a8bd);

  // Kept as aliases for the small shared widgets that use the original names.
  static const night = voidBlack;
  static const gold = cyan;
  static const paper = panel;

  static ThemeData get theme {
    final scheme = const ColorScheme.dark(
      primary: cyan,
      onPrimary: voidBlack,
      secondary: magenta,
      onSecondary: voidBlack,
      surface: panel,
      onSurface: text,
      error: Color(0xffff647c),
      onError: voidBlack,
    );
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: 'TaskLabText',
      colorScheme: scheme,
      scaffoldBackgroundColor: voidBlack,
    );
    return base.copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: voidBlack,
        foregroundColor: cyan,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      textTheme: base.textTheme.copyWith(
        headlineSmall: const TextStyle(
          fontFamily: 'TaskLabText',
          fontSize: 27,
          color: text,
          fontWeight: FontWeight.w700,
        ),
        titleLarge: const TextStyle(
          fontFamily: 'TaskLabText',
          fontSize: 23,
          color: text,
          fontWeight: FontWeight.w700,
        ),
        bodyMedium: const TextStyle(color: text),
        bodySmall: const TextStyle(color: muted),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: panel,
        labelStyle: const TextStyle(color: muted),
        hintStyle: const TextStyle(color: muted),
        prefixIconColor: cyan,
        suffixIconColor: cyan,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xff383b50)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xff383b50)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: cyan, width: 1.5),
        ),
      ),
      cardTheme: CardThemeData(
        color: panel,
        surfaceTintColor: Colors.transparent,
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xff34374d)),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: cyan,
          foregroundColor: voidBlack,
          minimumSize: const Size(48, 48),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: cyan,
          side: const BorderSide(color: cyan),
          minimumSize: const Size(48, 48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: magenta,
        foregroundColor: voidBlack,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: panel,
        indicatorColor: cyan.withValues(alpha: 0.16),
        labelTextStyle: WidgetStateProperty.resolveWith((states) => TextStyle(
          color: states.contains(WidgetState.selected) ? cyan : muted,
          fontWeight: states.contains(WidgetState.selected) ? FontWeight.w700 : FontWeight.normal,
        )),
        iconTheme: WidgetStateProperty.resolveWith((states) => IconThemeData(
          color: states.contains(WidgetState.selected) ? cyan : muted,
        )),
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: Color(0xff292c40),
        contentTextStyle: TextStyle(color: text),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(color: cyan),
      dividerColor: const Color(0xff34374d),
    );
  }
}
