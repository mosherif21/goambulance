import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/features/first_aid/components/first_aid_tips_details_page.dart';

import '../../../constants/app_init_constants.dart';
import '../controllers/first_aid_assets.dart';

class FirstAidCard extends StatelessWidget {
  const FirstAidCard({Key? key, required this.firstAidNumber})
      : super(key: key);
  final int firstAidNumber;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(
        () => FirstAidTipsDetailsPage(
          imgPath: getFirstAidDetailsPath(firstAidNumber),
        ),
        transition: AppInit.getPageTransition(),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10.0),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 15.0),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: AssetImage(
                  getFirstAidTipImage(firstAidNumber),
                ),
                height: 35.0,
              ),
              const SizedBox(width: 5.0),
              AutoSizeText(
                'firstAidTips$firstAidNumber'.tr,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
              ),
              const Spacer(),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.black54,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
