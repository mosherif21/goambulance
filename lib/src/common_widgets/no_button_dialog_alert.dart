import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:goambulance/src/constants/app_init_constants.dart';

class NoButtonDialogAlert {
  final String title;
  final Widget content;
  final BuildContext context;
  final bool dismissible;
  const NoButtonDialogAlert({
    required this.title,
    required this.content,
    required this.context,
    required this.dismissible,
  });
  showNoButtonAlertDialog() => AppInit.isIos
      ? showCupertinoDialog(
          context: context,
          builder: (BuildContext context) => CupertinoAlertDialog(
            title: Text(title),
            content: content,
          ),
          barrierDismissible: dismissible,
        )
      : showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text(title),
            content: content,
          ),
          barrierDismissible: dismissible,
        );
}
