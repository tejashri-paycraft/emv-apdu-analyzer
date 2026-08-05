import 'package:flutter/material.dart';

class AppTheme {
  static const Color background = Color(0xff0F172A);

  static const Color panel = Color(0xff1E293B);

  static const Color border = Color(0xff334155);

  static const Color primary = Color(0xff6366F1);

  static const Color success = Color(0xff22C55E);

  static const Color danger = Color(0xffEF4444);

  static const Color text = Color(0xffF8FAFC);

  static const Color subtitle = Color(0xff94A3B8);

  static ThemeData dark() {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      primaryColor: primary,
      fontFamily: "Roboto",
      cardColor: panel,

      colorScheme: const ColorScheme.dark(primary: primary, surface: panel),

      dividerColor: border,

      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: background,
        centerTitle: false,
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: panel,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: border),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: border),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: primary),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(140, 45),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
