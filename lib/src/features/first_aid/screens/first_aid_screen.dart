import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/general/common_widgets/back_button.dart';
import 'package:goambulance/src/general/common_widgets/regular_clickable_card.dart';

import '../../../constants/app_init_constants.dart';
import '../../../general/common_functions.dart';
import '../components/first_aid_tips_details_page.dart';
import '../controllers/first_aid_assets.dart';

class FirstAidScreen extends StatelessWidget {
  const FirstAidScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = getScreenHeight(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
                top: 5.0, bottom: 20.0, left: 20.0, right: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const RegularBackButton(),
                Text(
                  'firstAid'.tr,
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                for (int firstAidNumber = 1;
                    firstAidNumber <= 17;
                    firstAidNumber++)
                  RegularClickableCard(
                    onPressed: () => Get.to(
                      () => FirstAidTipsDetailsPage(
                        imgPath: getFirstAidDetailsPath(firstAidNumber),
                      ),
                      transition: AppInit.getPageTransition(),
                    ),
                    title: 'firstAidTips$firstAidNumber'.tr,
                    subTitle: '',
                    icon: Icons.arrow_forward_ios,
                    iconColor: Colors.black54,
                    imgPath: getFirstAidTipImage(firstAidNumber),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
