import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/general/common_widgets/back_button.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../general/common_widgets/regular_clickable_card_no_photo.dart';

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
        scrolledUnderElevation: 5,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
          child: StretchingOverscrollIndicator(
            axisDirection: AxisDirection.down,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListView.builder(
                    itemBuilder: (BuildContext context, int count) {
                      return RegularClickableCardNoP(
                        onPressed: () {
                          switch (count) {
                            case 0:
                              // Get.to(
                              //   () => const EditUserDataPage(),
                              //   transition: getPageTransition(),
                              // );
                              break;
                            case 1:
                              // Get.to(
                              //   () => const AccountAddressesPage(),
                              //   transition: getPageTransition(),
                              // );
                              break;
                            case 2:
                              // Get.to(
                              //   () => const EditMedicalHistoryPage(),
                              //   transition: getPageTransition(),
                              // );
                              break;
                            case 3:
                              _launchUrl(url);
                              break;
                          }
                        },
                        title: 'aboutUsTitle${count + 1}'.tr,
                        subTitle: '',
                        icon: Icons.arrow_forward_ios,
                        iconColor: Colors.black45,
                      );
                    },
                    itemCount: 4,
                    shrinkWrap: true,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _launchUrl(String siteUrl) async {
    final Uri url = Uri.parse(siteUrl);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch ');
    }
  }
}
