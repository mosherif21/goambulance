import 'package:flutter/material.dart';
import 'package:goambulance/src/constants/sizes.dart';

import 'colors.dart';

//-- Default Text Styles
const darkDefaultHeaderTextStyle = TextStyle(color: Colors.white, fontSize: 25);
const darkDefaultSubTextStyle = TextStyle(color: Colors.white70, fontSize: 15);
const darkDefaultButtonTextStyle =
    TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500);
const lightDefaultHeaderTextStyle =
    TextStyle(color: Colors.black, fontSize: 25);
const lightDefaultButtonTextStyle =
    TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w500);
const lightDefaultSubTextStyle = TextStyle(color: Colors.black87, fontSize: 15);

//--Default Button Styles
ButtonStyle kOutlinedButtonStyle = OutlinedButton.styleFrom(
  shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(5))),
  foregroundColor: kDarkishColor,
  side: const BorderSide(color: kDarkishColor),
  padding: const EdgeInsets.symmetric(vertical: kButtonHeight),
);

ButtonStyle kElevatedButtonStyle = ElevatedButton.styleFrom(
  elevation: 0,
  shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(5))),
  foregroundColor: kDarkishColor,
  padding: const EdgeInsets.symmetric(vertical: kButtonHeight),
);

ButtonStyle kElevatedButtonRegularStyle = ElevatedButton.styleFrom(
  elevation: 0,
  backgroundColor: Colors.black,
  foregroundColor: Colors.white,
);
