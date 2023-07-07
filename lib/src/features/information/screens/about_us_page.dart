import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/features/information/components/web_page.dart';
import 'package:goambulance/src/general/common_widgets/back_button.dart';

import '../../../general/common_widgets/regular_clickable_card_no_photo.dart';
import '../../../general/general_functions.dart';
import '../components/privacy_policy.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({Key? key}) : super(key: key);
  final String url = 'https://goambulance.help';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: const RegularBackButton(padding: 0),
        title: AutoSizeText(
          'aboutUs'.tr,
          maxLines: 1,
        ),
        titleTextStyle: const TextStyle(
            fontSize: 25, fontWeight: FontWeight.w600, color: Colors.black),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: StretchingOverscrollIndicator(
            axisDirection: AxisDirection.down,
            child: ListView.builder(
              itemBuilder: (BuildContext context, int count) {
                return RegularClickableCardNoP(
                  onPressed: () {
                    switch (count) {
                      case 0:
                        Get.to(
                          () => PrivacyPolicyWebView(),
                          transition: getPageTransition(),
                        );
                        break;
                      case 1:
                        Get.to(
                          () => OurWebPageView(),
                          transition: getPageTransition(),
                        );
                        break;
                    }
                  },
                  title: 'aboutUsTitle${count + 1}'.tr,
                  subTitle: '',
                  icon: Icons.arrow_forward_ios,
                  iconColor: Colors.black45,
                );
              },
              itemCount: 2,
            ),
          ),
        ),
      ),
    );
  }
}
