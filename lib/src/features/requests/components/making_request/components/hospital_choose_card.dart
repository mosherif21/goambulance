import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/features/requests/components/making_request/models.dart';
import 'package:line_icons/line_icon.dart';

import '../../../../../general/general_functions.dart';

class HospitalChooseCard extends StatelessWidget {
  const HospitalChooseCard({
    Key? key,
    required this.hospitalItem,
    required this.selected,
    required this.onPress,
  }) : super(key: key);
  final HospitalModel hospitalItem;
  final bool selected;
  final Function onPress;
  @override
  Widget build(BuildContext context) {
    final screenHeight = getScreenHeight(context);
    return  Material(
        shadowColor: Colors.grey.shade300,
        color: selected ? Colors.grey.shade300 : Colors.white,
        child: InkWell(
          splashFactory: InkSparkle.splashFactory,
          onTap: selected ? null : () => onPress(),
          highlightColor: Colors.grey.shade200,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                LineIcon.hospital(
                  size: screenHeight * 0.07,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
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
                        '${'avgPrice'.tr}: ${hospitalItem.avgPrice} ${'egp'.tr}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey,
                        ),
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }
}
