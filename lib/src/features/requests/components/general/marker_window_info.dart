import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../general/general_functions.dart';

class MarkerWindowInfo extends StatelessWidget {
  const MarkerWindowInfo({
    Key? key,
    required this.time,
    required this.title,
    required this.onTap,
    required this.toHospital,
  }) : super(key: key);
  final int time;
  final String title;
  final bool toHospital;
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
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Column(
            crossAxisAlignment: time != 0
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (time != 0)
                AutoSizeText(
                  (toHospital ? 'arriveIn' : 'pickupIn').trParams({
                    'routeTime': '${time.toString()} ${getMinutesString(time)}',
                  }),
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 5,
                    color: Colors.grey,
                  ),
                  maxLines: 1,
                ),
              AutoSizeText(
                title,
                minFontSize: 14,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: Colors.black,
                  overflow: TextOverflow.ellipsis,
                ),
                maxLines: 1,
              ),
            ],
          ),
        ),
        onTap: () => onTap(),
      ),
    );
  }
}
