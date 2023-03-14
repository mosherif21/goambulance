import 'package:flutter/material.dart';
import 'package:goambulance/src/constants/app_init_constants.dart';

class TextFormFieldRegularInitialText extends StatelessWidget {
  const TextFormFieldRegularInitialText({
    Key? key,
    required this.labelText,
    required this.hintText,
    required this.prefixIconData,
    required this.textController,
    required this.inputType,
    required this.initialText,
  }) : super(key: key);
  final String labelText;
  final String hintText;
  final String initialText;
  final IconData prefixIconData;
  final TextEditingController textController;
  final InputType inputType;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textController,
      initialValue: initialText,
      keyboardType: inputType == InputType.email
          ? TextInputType.emailAddress
          : TextInputType.text,
      decoration: InputDecoration(
        prefixIcon: Icon(
          prefixIconData,
        ),
        labelText: labelText,
        hintText: hintText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
    );
  }
}
