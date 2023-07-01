import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TextFormFieldPassword extends StatelessWidget {
  const TextFormFieldPassword({
    Key? key,
    required this.labelText,
    required this.textController,
    required this.textInputAction,
    this.onSubmitted,
    required this.validationFunction,
  }) : super(key: key);
  final String labelText;
  final TextEditingController textController;
  final TextInputAction textInputAction;
  final Function? onSubmitted;
  final String? Function(String?)? validationFunction;

  @override
  Widget build(BuildContext context) {
    RxBool passwordHide = true.obs;
    return Obx(
      () => TextFormField(
        textInputAction: textInputAction,
        onFieldSubmitted:
            onSubmitted != null ? (enteredString) => onSubmitted!() : null,
        obscureText: passwordHide.value,
        controller: textController,
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.lock_outlined,
          ),
          labelText: labelText,
          hintText: 'passwordHintLabel'.tr,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          suffixIcon: IconButton(
            onPressed: () => passwordHide.value
                ? passwordHide.value = false
                : passwordHide.value = true,
            icon: Icon(passwordHide.value
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined),
          ),
        ),
        validator: validationFunction,
      ),
    );
  }
}
