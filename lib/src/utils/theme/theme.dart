import 'package:flutter/material.dart';
import 'package:goambulance/src/utils/theme/widget_themes/text_theme.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    bottomSheetTheme:
        BottomSheetThemeData(backgroundColor: Colors.black.withOpacity(0)),
    primarySwatch: const MaterialColor(
      0xFF28AADC,
      <int, Color>{
        50: Color(0xFF28AADC),
        100: Color(0xFF28AADC),
        200: Color(0xFF28AADC),
        300: Color(0xFF28AADC),
        400: Color(0xFF28AADC),
        500: Color(0xFF28AADC),
        600: Color(0xFF28AADC),
        700: Color(0xFF28AADC),
        800: Color(0xFF28AADC),
        900: Color(0xFF28AADC),
      },
    ),
    textTheme: ATextTheme.lightTextTheme,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(),
    ),
  );
}
