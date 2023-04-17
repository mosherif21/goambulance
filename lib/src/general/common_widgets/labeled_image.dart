import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

Widget clickableLabeledImage({
  required img,
  required label,
}) {
  return ClipRRect(
    borderRadius: const BorderRadius.all(Radius.circular(5.0)),
    child: Stack(
      children: <Widget>[
        Container(
            color: Colors.white,
            padding: const EdgeInsets.all(15),
            child: Image.asset(img, fit: BoxFit.contain, width: 1000.0)),
        Positioned(
          bottom: 0.0,
          left: 0.0,
          right: 0.0,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(200, 0, 0, 0),
                  Color.fromARGB(0, 0, 0, 0)
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            child: AutoSizeText(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
            ),
          ),
        ),
      ],
    ),
  );
}
