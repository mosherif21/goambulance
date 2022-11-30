import 'package:flutter/material.dart';

class TextFormFieldRegular extends StatelessWidget {
  const TextFormFieldRegular({
    Key? key,
    required this.labelText,
    required this.hintText,
    required this.prefixIconData,
    required this.color,
  }) : super(key: key);
  final String labelText;
  final String hintText;
  final IconData prefixIconData;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: (string) {},
      cursorColor: color,
      decoration: InputDecoration(
        prefixIcon: Icon(
          prefixIconData,
        ),
        labelText: labelText,
        hintText: hintText,
        border: const OutlineInputBorder(),
        floatingLabelStyle: TextStyle(color: color),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: color,
          ),
        ),
      ),
    );
  }
}
