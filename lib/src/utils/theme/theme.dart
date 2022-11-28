import 'package:flutter/material.dart';
import 'package:goambulance/src/utils/theme/widget_themes/text_theme.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: const MaterialColor(
      0xFF28AADC,
      <int, Color>{
        50: Color(0xFF006ee6),
        100: Color(0xFF0062cc),
        200: Color(0xFF0055b3),
        300: Color(0xFF004999),
        400: Color(0xFF003d80),
        500: Color(0xFF003166),
        600: Color(0xFF00254d),
        700: Color(0xFF001833),
        800: Color(0xFF001833),
        900: Color(0xFF000c19),
      },
    ),
    textTheme: ATextTheme.lightTextTheme,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(),
    ),
  );
/*
  static ThemeData darkTheme = ThemeData(
    textTheme: ATextTheme.darkTextTheme,
    primarySwatch: const MaterialColor(
      0xFF003d80,
      <int, Color>{
        50: Color(0xFF006ee6),
        100: Color(0xFF0062cc),
        200: Color(0xFF0055b3),
        300: Color(0xFF004999),
        400: Color(0xFF003d80),
        500: Color(0xFF003166),
        600: Color(0xFF00254d),
        700: Color(0xFF001833),
        800: Color(0xFF001833),
        900: Color(0xFF000c19),
      },
    ),
  );*/
}
