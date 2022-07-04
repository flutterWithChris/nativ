import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    drawerTheme: DrawerThemeData(
        backgroundColor: const Color(0xff515A5E).withAlpha(255)),
    appBarTheme: AppBarTheme(
        actionsIconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xff515A5E).withAlpha(255),
        titleTextStyle: TextStyle(
            fontFamily: GoogleFonts.lekton().fontFamily,
            color: Colors.white,
            fontSize: 22),
        systemOverlayStyle: SystemUiOverlayStyle.light),
    //  canvasColor: const Color(0xff515A5E),
    // backgroundColor: const Color(0xff515A5E),
    scaffoldBackgroundColor: const Color(0xff35515E).withAlpha(255),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white70,
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(45.0),
          borderSide: const BorderSide(width: 0, style: BorderStyle.none)),
    ),
    textTheme: GoogleFonts.lektonTextTheme()
        .apply(bodyColor: Colors.white, displayColor: Colors.white),
    chipTheme: const ChipThemeData(),
    // primaryColor: const Color(0xff515A5E),
    colorSchemeSeed: const Color(0xff515A5E).withAlpha(255),
    useMaterial3: true,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
        fixedSize: const Size(200, 35),
      ),
    ),
  ),
};
