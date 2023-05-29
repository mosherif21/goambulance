import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class MarkerWindowInfo extends StatelessWidget {
  const MarkerWindowInfo({
    Key? key,
    required this.title,
    required this.subTitle,
    required this.startLocation,
    required this.onTap,
  }) : super(key: key);
  final String title;
  final String subTitle;
  final bool startLocation;
  final Function onTap;
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      color: Colors.white,
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      child: InkWell(
        splashFactory: InkSparkle.splashFactory,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Expanded(
                child: AutoSizeText(title),
              ),
              Expanded(
                child: AutoSizeText(title),
              ),
            ],
          ),
        ),
        onTap: () => onTap(),
      ),
    );
  }
}
