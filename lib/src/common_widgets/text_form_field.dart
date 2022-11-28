import 'package:flutter/material.dart';

class TextFormFieldRegular extends StatelessWidget {
  const TextFormFieldRegular({
    Key? key,
    required this.labelText,
    required this.hintText,
    required this.prefixIconData,
  }) : super(key: key);
  final String labelText;
  final String hintText;
  final IconData prefixIconData;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        prefixIcon: Icon(
          prefixIconData,
        ),
        labelText: labelText,
        hintText: hintText,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
