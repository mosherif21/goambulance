import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../constants/enums.dart';
import '../../../../../general/general_functions.dart';

class MarkerWindowInfo extends StatelessWidget {
  const MarkerWindowInfo({
    Key? key,
    required this.time,
    required this.title,
    required this.windowType,
    required this.onTap,
  }) : super(key: key);
  final RxnInt time;
  final String title;
  final MarkerWindowType windowType;
  final Function onTap;
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      color: windowType == MarkerWindowType.requestLocation
          ? Colors.white
          : Colors.black,
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      child: InkWell(
        splashFactory: InkSparkle.splashFactory,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Obx(
            () => Column(
              crossAxisAlignment: time.value != null
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(
                  () => time.value != null &&
                          windowType != MarkerWindowType.ambulanceLocation
                      ? AutoSizeText(
                          windowType == MarkerWindowType.requestLocation
                              ? 'pickupIn'.trParams({
                                  'routeTime':
                                      '${time.value!.toString()} ${getMinutesString(time.value!)}',
                                })
                              : '${'arriveBy'.tr} ${getAddedCurrentTime(minutesToAdd: time.value! * 2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 5,
                            color: Colors.grey,
                          ),
                          maxLines: 1,
                        )
                      : const SizedBox.shrink(),
                ),
                AutoSizeText(
                  title,
                  minFontSize: 14,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                    color: windowType == MarkerWindowType.requestLocation
                        ? Colors.black
                        : Colors.white,
                    overflow: TextOverflow.ellipsis,
                  ),
                  maxLines: 1,
                ),
              ],
            ),
          ),
        ),
        onTap: () => onTap(),
      ),
    );
  }
}
