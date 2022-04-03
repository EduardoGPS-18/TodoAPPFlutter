import 'package:flutter/material.dart';

mixin AppTheme {
  static ThemeData get themeData {
    const primarySwatch = Colors.blue;
    return ThemeData(
      primarySwatch: primarySwatch,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          padding: MaterialStateProperty.all<EdgeInsets>(
            const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 24,
            ),
          ),
          shape: MaterialStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        alignLabelWithHint: true,
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: primarySwatch,
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        border: OutlineInputBorder(
          borderSide: const BorderSide(
            color: primarySwatch,
          ),
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: primarySwatch,
        onPrimary: Colors.white,
        secondary: Colors.lightBlue,
        onSecondary: Colors.white,
        error: Colors.red,
        onError: Colors.white,
        background: Colors.white,
        onBackground: Colors.black,
        surface: Colors.white,
        onSurface: Colors.grey,
      ),
    );
  }
}
