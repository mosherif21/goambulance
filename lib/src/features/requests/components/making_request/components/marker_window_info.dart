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
      borderRadius: const BorderRadius.all(Radius.circular(5)),
      child: InkWell(
        splashFactory: InkSparkle.splashFactory,
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(
                () => time.value != null &&
                        windowType != MarkerWindowType.ambulanceLocation
                    ? AutoSizeText(
                        windowType == MarkerWindowType.requestLocation
                            ? 'pickupIn'.trParams({
                                'routeTime': time.value!.toString(),
                              })
                            : '${'arriveBy'.tr} ${getAddedCurrentTime(minutesToAdd: time.value!)}',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 10,
                          color: windowType == MarkerWindowType.requestLocation
                              ? Colors.grey
                              : Colors.white,
                        ),
                        maxLines: 1,
                      )
                    : const SizedBox.shrink(),
              ),
              AutoSizeText(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
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
        onTap: () => onTap(),
      ),
    );
  }
}
