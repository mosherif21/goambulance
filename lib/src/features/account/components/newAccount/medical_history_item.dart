import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constants/app_init_constants.dart';
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
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'disease',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: screenHeight * 0.015,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Bruno Ace',
                ),
              ),
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image(
                    image: const AssetImage(kVirusImg),
                    height: screenHeight * 0.1,
                  ),
                  SizedBox(width: screenHeight * 0.01),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'item',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: screenHeight * 0.02,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Bruno Ace',
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      Row(
                        children: [
                          Text(
                            'countIs'.tr,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: screenHeight * 0.015,
                              fontFamily: 'Bruno Ace',
                            ),
                          ),
                          const SizedBox(width: 5.0),
                          Text(
                            '299',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: screenHeight * 0.015,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Bruno Ace',
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              )
            ],
          ),
          Positioned(
            right:
                AppInit.currentDeviceLanguage == Language.english ? 10.0 : null,
            left:
                AppInit.currentDeviceLanguage == Language.arabic ? 10.0 : null,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: IconButton(
                    icon: Icon(
                      Icons.settings,
                      size: screenHeight * 0.05,
                    ),
                    color: Colors.black,
                    onPressed: () {},
                  ),
                ),
                SizedBox(height: screenHeight * 0.005),
                IconButton(
                  icon: Icon(
                    Icons.close,
                    size: screenHeight * 0.05,
                  ),
                  color: Colors.black,
                  onPressed: () async {},
                ),
                SizedBox(height: screenHeight * 0.005),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
