import 'package:flutter/material.dart';
import 'package:goambulance/src/general/app_init.dart';
import 'package:google_fonts/google_fonts.dart';

class ATextTheme {
  ATextTheme._();
  static TextTheme lightTextTheme = TextTheme(
    displayMedium: GoogleFonts.montserrat(
      color: Colors.black87,
    ),
    displaySmall: GoogleFonts.montserrat(
      color: Colors.black87,
      fontSize: AppInit.notWebMobile ? 20 : 14,
      fontWeight: FontWeight.w700,
    ),
    headlineSmall: GoogleFonts.montserrat(
      color: Colors.black,
      fontSize: AppInit.notWebMobile ? 25 : 14,
      fontWeight: FontWeight.w700,
    ),
    titleLarge: GoogleFonts.montserrat(
      color: Colors.black87,
      fontSize: AppInit.notWebMobile ? 18 : 10,
      fontWeight: FontWeight.w300,
    ),
    titleSmall: GoogleFonts.poppins(
        color: Colors.black54, fontSize: AppInit.notWebMobile ? 20 : 14),
  );
}
