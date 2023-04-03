import 'package:flutter/material.dart';

class CircleButtonIconAndText extends StatelessWidget {
  const CircleButtonIconAndText({
    super.key,
    required this.onPressed,
    required this.buttonText,
    required this.iconColor,
    required this.buttonColor,
    required this.icon,
  });
  final Function onPressed;
  final String buttonText;
  final Widget icon;
  final Color iconColor;
  final Color buttonColor;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Material(
          shape: const CircleBorder(),
          color: buttonColor,
          child: InkWell(
            customBorder: const CircleBorder(),
            splashFactory: InkSparkle.splashFactory,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: icon,
            ),
            onTap: () => onPressed(),
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
