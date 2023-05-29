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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.account_circle,
                      color: Colors.white,
                      size: 30,
                    ),
                    SizedBox(
                      width: 8.0,
                    ),
                    Text(
                      "I am here",
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        onTap: () => onTap(),
      ),
    );
  }
}
