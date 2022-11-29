import 'package:flutter/material.dart';

class TextFormFieldRegularSuffixIcon extends StatelessWidget {
  const TextFormFieldRegularSuffixIcon(
      {Key? key,
      required this.labelText,
      required this.hintText,
      required this.prefixIconData,
      required this.suffixIconData,
      required this.suffixIconButtonOnPressed})
      : super(key: key);
  final String labelText;
  final String hintText;
  final IconData prefixIconData;
  final IconData suffixIconData;
  final Function suffixIconButtonOnPressed;
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
        suffixIcon: IconButton(
          onPressed: () => suffixIconButtonOnPressed(),
          icon: Icon(
            suffixIconData,
          ),
        ),
      ),
    );
  }
}
