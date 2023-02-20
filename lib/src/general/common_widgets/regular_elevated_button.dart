import 'package:flutter/material.dart';

import '../../constants/styles.dart';

class RegularElevatedButton extends StatelessWidget {
  const RegularElevatedButton({
    Key? key,
    required this.buttonText,
    required this.onPressed,
    required this.enabled,
  }) : super(key: key);
  final String buttonText;
  final Function onPressed;
  final bool enabled;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: kElevatedButtonRegularStyle,
        onPressed: () => enabled ? onPressed() : null,
        child: Text(
          buttonText,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
