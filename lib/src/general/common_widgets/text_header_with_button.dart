import 'package:flutter/material.dart';

class TextHeaderWithButton extends StatelessWidget {
  const TextHeaderWithButton(
      {Key? key,
      required this.headerText,
      required this.onPressed,
      required this.buttonText})
      : super(key: key);
  final String headerText;
  final Function onPressed;
  final String buttonText;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
          child: Text(
            headerText,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const Spacer(),
        TextButton(
          style: TextButton.styleFrom(),
          onPressed: () => onPressed,
          child: Text(
            buttonText,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
