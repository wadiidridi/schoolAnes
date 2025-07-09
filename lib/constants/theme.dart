import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color(0xFF626F47);
  static const Color secondary = Color(0xFFA0B15A);
  static const Color background = Color(0xFFF6EDD5);
  static const Color accent = Color(0xFFF7C67B);

  static ThemeData get lightTheme => ThemeData(
    primaryColor: primary,
    scaffoldBackgroundColor: background,
    colorScheme: const ColorScheme.light(
      primary: primary,
      secondary: secondary,
      background: background,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black),
    ),
  );



}
