import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/features/requests/components/making_request/models.dart';
import 'package:goambulance/src/features/requests/controllers/making_request_location_controller.dart';
import 'package:line_icons/line_icon.dart';

import '../../../../../general/general_functions.dart';

class HospitalChooseCard extends StatelessWidget {
  const HospitalChooseCard({
    Key? key,
    required this.hospitalItem,
    required this.controller,
  }) : super(key: key);
  final HospitalModel hospitalItem;
  final MakingRequestLocationController controller;
  @override
  Widget build(BuildContext context) {
    final screenHeight = getScreenHeight(context);
    return Obx(
      () => Material(
        shadowColor: Colors.grey.shade300,
        color: controller.selectedHospital.value == hospitalItem
            ? Colors.grey.shade300
            : Colors.white,
        child: InkWell(
          splashFactory: InkSparkle.splashFactory,
          onTap: () => controller.selectedHospital.value == hospitalItem
              ? null
              : controller.onHospitalChosen(hospitalItem: hospitalItem),
          highlightColor: Colors.grey.shade200,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LineIcon.hospital(
                  size: screenHeight * 0.07,
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoSizeText(
                      hospitalItem.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                      maxLines: 1,
                    ),
                    const SizedBox(height: 5),
                    AutoSizeText(
                      hospitalItem.avgPrice,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey,
                      ),
                      maxLines: 1,
                    ),
                  ],
                ),
                const Spacer(),
                Obx(
                  () => controller.selectedHospital.value == hospitalItem &&
                          controller.routeToHospitalTime.isNotEmpty
                      ? Row(
                          children: [
                            const Icon(Icons.access_time_outlined),
                            const SizedBox(width: 2),
                            AutoSizeText(
                              controller.routeToHospitalTime.value,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                              maxLines: 1,
                            ),
                          ],
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
