import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class RoundedImageElevatedButton extends StatelessWidget {
  const RoundedImageElevatedButton(
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
    return Material(
      borderRadius: const BorderRadius.all(Radius.circular(15)),
      color: Colors.grey.shade200,
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        splashFactory: InkSparkle.splashFactory,
        onTap: () => onPressed(),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                imagePath,
                height: 55,
              ),
              const SizedBox(height: 6),
              Text(buttonText),
            ],
          ),
        ),
      ),
    );
  }
}
