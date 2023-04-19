import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class RegularElevatedButton extends StatelessWidget {
  const RegularElevatedButton({
    Key? key,
    required this.buttonText,
    required this.onPressed,
    required this.enabled,
    required this.color,
    this.fontSize = 15,
  }) : super(key: key);
  final String buttonText;
  final Function onPressed;
  final bool enabled;
  final Color color;
  final double? fontSize;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 45,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          splashFactory: InkSparkle.splashFactory,
          elevation: 0,
          backgroundColor: color,
          foregroundColor: Colors.white,
        ),
        onPressed: () => enabled ? onPressed() : null,
        child: AutoSizeText(
          buttonText,
          style: TextStyle(
              color: Colors.white,
              fontSize: fontSize,
              fontWeight: FontWeight.w500),
          maxLines: 1,
        ),
      ),
    );
  }
}
