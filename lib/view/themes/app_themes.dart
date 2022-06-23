import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum AppTheme {
  Light,
  Dark,
}

final appThemeData = {
  AppTheme.Light: ThemeData(
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white70,
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(45.0),
          borderSide: const BorderSide(width: 0, style: BorderStyle.none)),
    ),
    textTheme: GoogleFonts.lektonTextTheme(),
    chipTheme: const ChipThemeData(),
    primaryColor: Colors.white,
    // colorSchemeSeed: const Color.fromARGB(255, 76, 94, 255),
    useMaterial3: true,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        fixedSize: const Size(250, 35),
      ),
    ),
  ),
  AppTheme.Dark: ThemeData(
    scaffoldBackgroundColor: Colors.black,
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white70,
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(45.0),
          borderSide: const BorderSide(width: 0, style: BorderStyle.none)),
    ),
    textTheme: GoogleFonts.lektonTextTheme(),
    chipTheme: const ChipThemeData(),
    primaryColor: Colors.white,
    // colorSchemeSeed: const Color.fromARGB(255, 76, 94, 255),
    useMaterial3: true,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        fixedSize: const Size(250, 35),
      ),
    ),
  ),
};
