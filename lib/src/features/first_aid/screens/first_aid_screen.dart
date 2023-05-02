import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/general/common_widgets/back_button.dart';

import '../../../general/common_widgets/regular_clickable_card.dart';
import '../../../general/general_functions.dart';
import '../components/first_aid_tips_details_page.dart';
import '../controllers/first_aid_assets.dart';

class FirstAidScreen extends StatelessWidget {
  const FirstAidScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const RegularBackButton(padding: 0),
        title: AutoSizeText(
          'firstAid'.tr,
          maxLines: 1,
        ),
        titleTextStyle: const TextStyle(
            fontSize: 25, fontWeight: FontWeight.w600, color: Colors.black),
        elevation: 0,
        scrolledUnderElevation: 5,
        backgroundColor: Colors.grey.shade100,
      ),
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20.0, left: 20.0, right: 20.0),
          child: StretchingOverscrollIndicator(
            axisDirection: AxisDirection.down,
            child: ListView.builder(
              itemBuilder: (BuildContext context, int firstAidNumber) {
                return RegularClickableCard(
                  onPressed: () => Get.to(
                    () => FirstAidTipsDetailsPage(
                      imgPath: getFirstAidDetailsPath(firstAidNumber + 1),
                    ),
                    transition: getPageTransition(),
                  ),
                  title: 'firstAidTips${firstAidNumber + 1}'.tr,
                  subTitle: '',
                  icon: Icons.arrow_forward_ios,
                  iconColor: Colors.black54,
                  imgPath: getFirstAidTipImage(firstAidNumber + 1),
                );
              },
              itemCount: 16,
              shrinkWrap: true,
            ),
          ),
        ),
      ),
    );
  }
}
