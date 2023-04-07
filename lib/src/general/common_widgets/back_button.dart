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
        splashRadius: 22,
        icon: const Center(child: Icon(Icons.arrow_back_ios)),
        onPressed: () => Get.back(),
      ),
    );
  }
}

class CustomBackButton extends StatelessWidget {
  const CustomBackButton(
      {Key? key, required this.onPressed, required this.padding})
      : super(key: key);
  final Function onPressed;
  final double padding;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Row(
        children: [
          IconButton(
            splashRadius: 22,
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => onPressed(),
          ),
        ],
      ),
    );
  }
}
