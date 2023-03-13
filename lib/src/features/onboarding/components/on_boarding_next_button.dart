import 'package:flutter/material.dart';

class OnBoardingPageNextButton extends StatelessWidget {
  const OnBoardingPageNextButton({
    Key? key,
    required this.onPress,
  }) : super(key: key);
  final Function onPress;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () => onPress(),
      style: ElevatedButton.styleFrom(
          side: const BorderSide(color: Colors.black54),
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(20.0),
          foregroundColor: Colors.white),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: const BoxDecoration(
          color: Colors.black87,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.arrow_forward_ios_sharp),
      ),
    );
  }
}
