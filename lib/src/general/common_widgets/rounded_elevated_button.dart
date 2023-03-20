import 'package:flutter/material.dart';

import '../../constants/app_init_constants.dart';
import '../common_functions.dart';

class RoundedElevatedButton extends StatelessWidget {
  const RoundedElevatedButton(
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
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ElevatedButton(
        onPressed: () => onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: Colors.grey.shade200,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15))),
          foregroundColor: Colors.grey.shade600,
          padding: const EdgeInsets.all(15),
          fixedSize: Size(AppInit.isWeb ? 130.0 : screenWidth * 0.35,
              AppInit.isWeb ? 100.0 : screenHeight * 0.12),
        ),
        child: Column(
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
