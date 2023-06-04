import 'package:flutter/material.dart';
import 'package:goambulance/src/general/app_init.dart';

class ATextTheme {
  ATextTheme._();
  static TextTheme lightTextTheme = TextTheme(
    displayMedium: const TextStyle(
      color: Colors.black87,
    ),
    displaySmall: TextStyle(
      color: Colors.black87,
      fontSize: AppInit.notWebMobile ? 20 : 14,
      fontWeight: FontWeight.w700,
    ),
    headlineSmall: TextStyle(
      color: Colors.black,
      fontSize: AppInit.notWebMobile ? 25 : 14,
      fontWeight: FontWeight.w700,
    ),
    titleLarge: TextStyle(
      color: Colors.black87,
      fontSize: AppInit.notWebMobile ? 18 : 10,
      fontWeight: FontWeight.w300,
    ),
    titleSmall: TextStyle(
        color: Colors.black54, fontSize: AppInit.notWebMobile ? 20 : 14),
  );
}
