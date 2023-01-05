import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/constants/app_init_constants.dart';

class SingleButtonDialogAlert {
  final String title;
  final Widget content;
  final String buttonText;
  final bool dismissible;
  final Function onPressed;
  final BuildContext context;

  const SingleButtonDialogAlert({
    required this.title,
    required this.content,
    required this.buttonText,
    required this.onPressed,
    required this.context,
    required this.dismissible,
  });
  showSingleButtonAlertDialog() => Get.dialog(
        AppInit.isIos
            ? CupertinoAlertDialog(
                title: Text(
                  title,
                  style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
                content:
                    WillPopScope(onWillPop: () async => false, child: content),
                actions: <Widget>[
                  TextButton(
                    onPressed: onPressed(),
                    child: Text(
                      buttonText,
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              )
            : AlertDialog(
                title: Text(
                  title,
                  style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
                content:
                    WillPopScope(onWillPop: () async => false, child: content),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => onPressed(),
                    child: Text(
                      buttonText,
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
        barrierDismissible: dismissible,
      );
}
