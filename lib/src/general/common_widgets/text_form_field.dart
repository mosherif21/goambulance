import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:goambulance/src/constants/app_init_constants.dart';

class TextFormFieldRegular extends StatelessWidget {
  const TextFormFieldRegular({
    Key? key,
    required this.labelText,
    required this.hintText,
    required this.prefixIconData,
    required this.textController,
    required this.inputType,
    required this.editable,
    required this.textInputAction,
    this.inputFormatter,
  }) : super(key: key);
  final String labelText;
  final String hintText;
  final IconData prefixIconData;
  final TextEditingController textController;
  final InputType inputType;
  final bool editable;
  final TextInputAction textInputAction;
  final TextInputFormatter? inputFormatter;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextFormField(
        textInputAction: textInputAction,
        inputFormatters: inputFormatter != null ? [inputFormatter!] : [],
        enabled: editable,
        controller: textController,
        keyboardType: inputType == InputType.email
            ? TextInputType.emailAddress
            : inputType == InputType.numbers
                ? TextInputType.number
                : TextInputType.text,
        decoration: InputDecoration(
          prefixIcon: Icon(
            prefixIconData,
          ),
          labelText: labelText,
          hintText: hintText,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
        ),
      ),
    );
  }
}
