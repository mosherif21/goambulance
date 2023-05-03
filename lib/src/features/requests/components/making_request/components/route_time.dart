import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../../../constants/assets_strings.dart';

class RouteTime extends StatelessWidget {
  const RouteTime({Key? key, required this.routeTime}) : super(key: key);
  final String routeTime;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        boxShadow: [
          BoxShadow(
            blurRadius: 1,
            color: Colors.grey.shade600,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            kRouteAnim,
            height: 35,
            frameRate: FrameRate.max,
          ),
          const SizedBox(width: 5),
          AutoSizeText(
            'routeTime'.trParams({
              'routeTime': routeTime,
            }),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Colors.black,
            ),
            maxLines: 1,
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }
}
