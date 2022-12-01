import 'package:flutter/material.dart';

import '../constants/styles.dart';

class RegularElevatedButton extends StatelessWidget {
  const RegularElevatedButton({
    Key? key,
    required this.buttonText,
    required this.height,
  }) : super(key: key);
  final String buttonText;
  final double height;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height * 0.05,
      child: ElevatedButton(
        style: kElevatedButtonRegularStyle,
        onPressed: () {},
        child: Text(
          buttonText,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
