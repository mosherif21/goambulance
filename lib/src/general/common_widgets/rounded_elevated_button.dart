import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class RoundedElevatedButton extends StatelessWidget {
  const RoundedElevatedButton({
    Key? key,
    required this.buttonText,
    required this.onPressed,
    required this.enabled,
    required this.color,
  }) : super(key: key);
  final String buttonText;
  final Function onPressed;
  final bool enabled;
  final Color color;
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
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(25))),
        ),
        onPressed: enabled ? () => onPressed() : null,
        child: AutoSizeText(
          buttonText,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
          maxLines: 1,
        ),
      ),
    );
  }
}
