import 'package:flutter/material.dart';

class CircleButtonIconAndText extends StatelessWidget {
  const CircleButtonIconAndText({
    super.key,
    required this.onPressed,
    required this.buttonText,
    required this.iconData,
    required this.iconColor,
    required this.buttonColor,
  });
  final Function onPressed;
  final String buttonText;
  final IconData iconData;
  final Color iconColor;
  final Color buttonColor;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(20.0),
              elevation: 0,
              backgroundColor: buttonColor,
              foregroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              shadowColor: Colors.white,
              shape: const CircleBorder()),
          onPressed: () => onPressed(),
          child: SizedBox(
            height: 40.0,
            child: Icon(
              iconData,
              color: iconColor,
            ),
          ),
        ),
        const SizedBox(height: 5.0),
        Text(
          buttonText,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
