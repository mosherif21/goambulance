import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/general/common_widgets/single_button_dialog_alert.dart';

class TextSingleButtonDialogue {
  final String title;
  final String body;
  final String buttonText;
  final Function onPressed;
  const TextSingleButtonDialogue(
      {required this.title,
      required this.body,
      required this.onPressed,
      required this.buttonText});

  showTextSingleButtonDialogue() => SingleButtonDialogAlert(
        title: title,
        content: Text(
          body,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        buttonText: buttonText,
        onPressed: () => onPressed(),
        context: Get.context!,
        dismissible: false,
      ).showSingleButtonAlertDialog();
}
