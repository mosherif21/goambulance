import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:goambulance/src/constants/app_init_constants.dart';

class SingleButtonDialogAlert {
  final String title;
  final Widget content;
  final String buttonText;
  final Function onPressed;
  final BuildContext context;
  final bool dismissible;
  const SingleButtonDialogAlert({
    required this.title,
    required this.content,
    required this.buttonText,
    required this.onPressed,
    required this.context,
    required this.dismissible,
  });
  showSingleButtonAlertDialog() => AppInit.isIos
      ? showCupertinoDialog(
          context: context,
          builder: (BuildContext context) => CupertinoAlertDialog(
            title: Text(title),
            content: content,
            actions: <Widget>[
              TextButton(
                onPressed: onPressed(),
                child: Text(buttonText),
              ),
            ],
          ),
          barrierDismissible: dismissible,
        )
      : showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text(title),
            content: content,
            actions: <Widget>[
              TextButton(
                onPressed: () => onPressed(),
                child: Text(buttonText),
              ),
            ],
          ),
          barrierDismissible: dismissible,
        );
}
