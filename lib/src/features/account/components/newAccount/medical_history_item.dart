import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../constants/assets_strings.dart';

class MedicalHistoryItem extends StatelessWidget {
  const MedicalHistoryItem({
    Key? key,
    required this.screenHeight,
  }) : super(key: key);
  final double screenHeight;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: const BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AutoSizeText(
                'disease',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
                maxLines: 1,
              ),
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SvgPicture.asset(
                    kMedicalHistoryItemImg,
                    height: screenHeight * 0.05,
                  ),
                  const SizedBox(height: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AutoSizeText(
                        'item',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          AutoSizeText(
                            'countIs'.tr,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontFamily: 'Bruno Ace',
                            ),
                            maxLines: 1,
                          ),
                          const SizedBox(width: 5.0),
                          const AutoSizeText(
                            '299',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Bruno Ace',
                            ),
                            maxLines: 1,
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              )
            ],
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(
              Icons.delete,
              size: 40,
              color: Colors.red,
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
