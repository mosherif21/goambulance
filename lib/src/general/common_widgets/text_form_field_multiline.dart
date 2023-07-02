import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFormFieldMultiline extends StatelessWidget {
  const TextFormFieldMultiline({
    Key? key,
    required this.labelText,
    required this.hintText,
    required this.textController,
    required this.textInputAction,
    this.inputFormatter,
    this.onSubmitted,
    this.validationFunction,
  }) : super(key: key);
  final String labelText;
  final String hintText;
  final TextEditingController textController;
  final TextInputAction textInputAction;
  final TextInputFormatter? inputFormatter;
  final Function? onSubmitted;
  final String? Function(String?)? validationFunction;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextFormField(
        textInputAction: textInputAction,
        maxLines: null,
        onFieldSubmitted:
            onSubmitted != null ? (enteredString) => onSubmitted!() : null,
        inputFormatters: inputFormatter != null ? [inputFormatter!] : [],
        controller: textController,
        keyboardType: TextInputType.multiline,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
        ),
        validator: validationFunction,
      ),
    );
  }
}
