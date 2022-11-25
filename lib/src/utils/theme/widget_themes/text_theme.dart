import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ATextTheme {
  ATextTheme._();
  static TextTheme lightTextTheme = TextTheme(
    headline2: GoogleFonts.montserrat(
      color: Colors.black87,
    ),
    headline3: GoogleFonts.montserrat(
      color: Colors.black87,
      fontSize: 25.0,
      fontWeight: FontWeight.w700,
    ),
    subtitle2: GoogleFonts.poppins(color: Colors.black54, fontSize: 24),
    headline4: GoogleFonts.montserrat(
      color: Colors.white,
      fontSize: 25.0,
      fontWeight: FontWeight.w700,
    ),
    subtitle1: GoogleFonts.poppins(color: Colors.white54, fontSize: 24),
  );
  static TextTheme darkTextTheme = TextTheme(
    headline2: GoogleFonts.montserrat(
      color: Colors.white,
    ),
    headline3: GoogleFonts.montserrat(
      color: Colors.white60,
      fontSize: 25.0,
      fontWeight: FontWeight.w700,
    ),
    subtitle2: GoogleFonts.poppins(color: Colors.white54, fontSize: 24),
    headline4: GoogleFonts.montserrat(
      color: Colors.black,
      fontSize: 25.0,
      fontWeight: FontWeight.w700,
    ),
    subtitle1: GoogleFonts.poppins(color: Colors.black54, fontSize: 24),
  );
}
