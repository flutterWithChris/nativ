import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum AppTheme {
  Light,
  Dark,
}

final appThemeData = {
  AppTheme.Light: ThemeData(
    scaffoldBackgroundColor: const Color(0xffF5FCFF),
    primaryTextTheme: const TextTheme(),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white70,
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(45.0),
          borderSide: const BorderSide(width: 0, style: BorderStyle.none)),
    ),
    textTheme: GoogleFonts.lektonTextTheme(),
    chipTheme: const ChipThemeData(),
    //primaryColor: const Color(0xffbfd5df),
    // bottomAppBarColor: Colors.white,
    colorSchemeSeed: const Color(0xffBFD5DF),
    useMaterial3: true,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        primary: const Color(0xff6E8691),
        //onPrimary: Colors.black38,
        textStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white70,
            fontFamily: GoogleFonts.lekton().fontFamily),
        // fixedSize: const Size(200, 35),
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
        fixedSize: const Size(200, 35),
      ),
    ),
  ),
};
