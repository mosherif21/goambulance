import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SingleButtonDialogAlert {
  final String title;
  final String content;
  final String buttonText;
  final Function onPressed;
  final BuildContext context;
  const SingleButtonDialogAlert(
    this.title,
    this.content,
    this.buttonText,
    this.onPressed,
    this.context,
  );
  showSingleButtonAlertDialog() => showCupertinoDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              onPressed: onPressed(),
              child: Text(buttonText),
            ),
          ],
        ),
      );
}
