import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

enum AppTheme {
  Light,
  Dark,
}

final appThemeData = {
  AppTheme.Light: ThemeData(
    useMaterial3: true,
    // * Colors
    scaffoldBackgroundColor: const Color(0xFFf9f9f8),
    cardColor: const Color(0xFF7b7b84),
    iconTheme: const IconThemeData(color: Color(0xfff37d64)),
    chipTheme: const ChipThemeData(backgroundColor: Color(0xffDED0BF)),
    colorSchemeSeed: const Color(0xffBFD5DF),
    cardTheme: const CardTheme(),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
        linearTrackColor: Colors.grey, circularTrackColor: Colors.grey),
    appBarTheme: const AppBarTheme(
        foregroundColor: Colors.white, backgroundColor: Color(0xFFf37d64)),
    listTileTheme: const ListTileThemeData(iconColor: Color(0xFFf37d64)),
    // * Button Styles
    outlinedButtonTheme: const OutlinedButtonThemeData(style: ButtonStyle()),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        primary: const Color(0xfff37d64),
        onPrimary: Colors.white,
        textStyle: TextStyle(
          fontFamily: GoogleFonts.nunito().fontFamily,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    // * Text Field Styles
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white70,
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(45.0),
          borderSide: const BorderSide(
              color: Colors.grey, width: 1, style: BorderStyle.none)),
    ),
    // * Fonts & Text Themes
    textTheme: GoogleFonts.nunitoTextTheme().apply(
        bodyColor: const Color(0xFF333333),
        displayColor: const Color(0xFF333333)),
  ),
  AppTheme.Dark: ThemeData(
    outlinedButtonTheme: const OutlinedButtonThemeData(
        style: ButtonStyle(
            foregroundColor: MaterialStatePropertyAll(Colors.white))),
    listTileTheme:
        const ListTileThemeData(iconColor: Colors.white, enableFeedback: true),
    iconTheme: const IconThemeData(color: Colors.white),
    drawerTheme: DrawerThemeData(
        backgroundColor: const Color(0xff515A5E).withAlpha(255)),
    appBarTheme: AppBarTheme(
        actionsIconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xff515A5E).withAlpha(255),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 22),
        systemOverlayStyle: SystemUiOverlayStyle.light),
    //  canvasColor: const Color(0xff515A5E),
    // backgroundColor: const Color(0xff515A5E),
    scaffoldBackgroundColor: const Color(0xff838282).withAlpha(255),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white70,
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(45.0),
          borderSide: const BorderSide(width: 0, style: BorderStyle.none)),
    ),
    textTheme: GoogleFonts.nunitoTextTheme()
        .apply(bodyColor: Colors.white, displayColor: Colors.white),
    canvasColor: Colors.transparent,
    chipTheme: const ChipThemeData(
      backgroundColor: Colors.transparent,
    ),
    cardTheme: const CardTheme(
      color: Color(0xffbb92cb),
    ),
    // primaryColor: const Color(0xff515A5E),
    colorSchemeSeed: const Color(0xff515A5E).withAlpha(255),
    useMaterial3: true,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        fixedSize: const Size(200, 35),
      ),
    ),
  ),
};
