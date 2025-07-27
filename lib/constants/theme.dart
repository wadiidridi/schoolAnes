import 'package:flutter/material.dart';

class AppTheme {
  // static const Color primary = Color(0xFF626F47);
  // static const Color secondary = Color(0xFFA0B15A);
  // static const Color background = Color(0xFFFFFFFF);
  // static const Color background = Color(0xFFF6EDD5);
  //
  //
  // static const Color accent = Color(0xFFF7C67B);


  static const Color primary = Color(0xFF7DA65D);      // Vert doux
  static const Color secondary = Color(0xFFD2E291);    // Vert clair pastel
  static const Color background = Color(0xFFFFF9EC);   // Beige crème
  static const Color accent = Color(0xFFFFD47E);       // Orange pastel

  static ThemeData get lightTheme => ThemeData(
  primaryColor: primary,
  scaffoldBackgroundColor: background,
  colorScheme: const ColorScheme.light(
  primary: primary,
  secondary: secondary,
  background: background,
  ),
  textTheme: const TextTheme(
  bodyLarge: TextStyle(
  fontFamily: 'ComicNeue',
  color: Colors.black,
  ),
  bodyMedium: TextStyle(
  fontFamily: 'ComicNeue',
  color: Colors.black,
  ),
  titleLarge: TextStyle(
  fontFamily: 'ComicNeue',
  fontWeight: FontWeight.bold,
  fontSize: 22,
  color: Colors.black,
  ),
  headlineSmall: TextStyle(
  fontFamily: 'ComicNeue',
  fontWeight: FontWeight.bold,
  fontSize: 26,
  color: Colors.black,
  ),
  ),
  );
  }