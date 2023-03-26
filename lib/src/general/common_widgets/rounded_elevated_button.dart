import 'package:flutter/material.dart';

import '../../constants/app_init_constants.dart';
import '../../constants/colors.dart';
import '../common_functions.dart';

class RoundedImageElevatedButton extends StatelessWidget {
  const RoundedImageElevatedButton(
      {Key? key,
      required this.buttonText,
      required this.imagePath,
      required this.onPressed})
      : super(key: key);
  final String buttonText;
  final String imagePath;
  final Function onPressed;
  @override
  Widget build(BuildContext context) {
    final screenWidth = getScreenWidth(context);
    final screenHeight = getScreenHeight(context);
    return SizedBox(
      height: AppInit.isWeb
          ? screenHeight <= 900
              ? 100
              : screenHeight * 0.11
          : screenHeight * 0.13,
      width: AppInit.isWeb ? 180.0 : screenWidth * 0.4,
      child: ElevatedButton(
        onPressed: () => onPressed(),
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: Colors.grey.shade200,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15))),
          foregroundColor: kDarkishColor,
          padding: EdgeInsets.all(AppInit.isWeb ? 18 : 15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              fit: BoxFit.contain,
              width: 40,
            ),
            const SizedBox(height: 5),
            Text(buttonText),
          ],
        ),
      ),
    );
  }
}
