import 'package:flutter/material.dart';

class RegularTextButton extends StatelessWidget {
  const RegularTextButton(
      {Key? key, required this.buttonText, required this.onPressed})
      : super(key: key);
  final String buttonText;
  final Function onPressed;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        splashFactory: InkSparkle.splashFactory,
      ),
      onPressed: () => onPressed(),
      child: Text(
        buttonText,
      ),
    );
  }
}
