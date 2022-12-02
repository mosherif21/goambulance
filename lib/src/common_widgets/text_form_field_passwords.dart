import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TextFormFieldPassword extends StatelessWidget {
  const TextFormFieldPassword({
    Key? key,
    required this.labelText,
    required this.textController,
  }) : super(key: key);
  final String labelText;
  final TextEditingController textController;

  @override
  Widget build(BuildContext context) {
    RxBool passwordHide = true.obs;
    return Obx(
      () => TextFormField(
        obscureText: passwordHide.value,
        controller: textController,
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.lock_outlined,
          ),
          labelText: labelText,
          hintText: 'passwordHintLabel'.tr,
          border: const OutlineInputBorder(),
          suffixIcon: IconButton(
            onPressed: () => passwordHide.value
                ? passwordHide.value = false
                : passwordHide.value = true,
            icon: Icon(passwordHide.value
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined),
          ),
        ),
      ),
    );
  }
}
