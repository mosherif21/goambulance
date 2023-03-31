import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegularBackButton extends StatelessWidget {
  const RegularBackButton({Key? key, required this.padding}) : super(key: key);
  final double padding;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: () => Get.back(),
      ),
    );
  }
}

class CustomBackButton extends StatelessWidget {
  const CustomBackButton(
      {Key? key, required this.onPressed, required this.buttonText})
      : super(key: key);
  final Function onPressed;
  final String buttonText;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => onPressed(),
        ),
        Text(
          buttonText,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
