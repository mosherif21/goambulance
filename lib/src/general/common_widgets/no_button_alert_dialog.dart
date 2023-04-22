import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/constants/app_init_constants.dart';

class NoButtonAlertDialog {
  final String title;
  final Widget content;
  final bool dismissible;
  final Color? backgroundColor;
  const NoButtonAlertDialog({
    this.backgroundColor,
    required this.title,
    required this.content,
    required this.dismissible,
  });
  showNoButtonAlertDialog() => Get.dialog(
        AppInit.isIos
            ? CupertinoAlertDialog(
                title: AutoSizeText(
                  title,
                  style: const TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                  maxLines: 1,
                ),
                content: WillPopScope(
                    onWillPop: () async => dismissible, child: content),
              )
            : AlertDialog(
                title: AutoSizeText(
                  title,
                  style: const TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                  maxLines: 1,
                ),
                content: WillPopScope(
                    onWillPop: () async => dismissible, child: content),
              ),
        barrierDismissible: dismissible,
      );
}
