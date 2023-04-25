import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:goambulance/src/features/requests/components/making_request/models.dart';
import 'package:line_icons/line_icon.dart';

import '../../../../../general/general_functions.dart';

class HospitalChooseCard extends StatelessWidget {
  const HospitalChooseCard({
    Key? key,
    required this.selected,
    required this.hospitalItem,
    required this.onPressed,
  }) : super(key: key);
  final Function onPressed;
  final bool selected;
  final HospitalModel hospitalItem;
  @override
  Widget build(BuildContext context) {
    final screenHeight = getScreenHeight(context);
    return Material(
      shadowColor: Colors.grey.shade300,
      color: selected ? Colors.grey.shade300 : Colors.white,
      child: InkWell(
        splashFactory: InkSparkle.splashFactory,
        onTap: () => selected ? null : onPressed(),
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
              AutoSizeText(
                hospitalItem.timeFromLocation.toString(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
                maxLines: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
