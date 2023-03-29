import 'package:badges/badges.dart' as badges;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/constants/app_init_constants.dart';
import 'package:goambulance/src/features/first_aid/controllers/first_aid_assets.dart';
import 'package:goambulance/src/features/first_aid/screens/first_aid_screen.dart';
import 'package:goambulance/src/features/home_screen/controllers/home_screen_controller.dart';
import 'package:goambulance/src/general/common_widgets/text_header.dart';

import '../../../constants/assets_strings.dart';
import '../../../general/common_widgets/clickable_labeled_image.dart';
import '../../../general/common_widgets/rounded_elevated_button.dart';
import '../../../general/common_widgets/text_header_with_button.dart';
import '../../first_aid/components/first_aid_tips_details_page.dart';

class HomeDashBoard extends StatelessWidget {
  const HomeDashBoard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeScreenController = HomeScreenController.instance;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        body: Container(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ValueListenableBuilder(
                      valueListenable: homeScreenController
                          .zoomDrawerController.stateNotifier!,
                      builder: (BuildContext context, DrawerState drawerState,
                          Widget? child) {
                        return IconButton(
                          onPressed: () {
                            homeScreenController.toggleDrawer();
                          },
                          icon: Icon(
                            homeScreenController.isDrawerOpen(drawerState)
                                ? Icons.close
                                : Icons.menu_outlined,
                            size: 30,
                          ),
                        );
                      },
                    ),
                    const Spacer(),
                    badges.Badge(
                      onTap: () {},
                      badgeContent: const Text('3'),
                      child: const Icon(
                        Icons.notifications,
                        size: 30,
                      ),
                    ),
                  ],
                ),
                TextHeaderWithButton(
                  headerText: 'firstAidTips'.tr,
                  onPressed: () => Get.to(() => const FirstAidScreen(),
                      transition: AppInit.getPageTransition()),
                  buttonText: 'viewAll'.tr,
                ),
                CarouselSlider(
                  carouselController: homeScreenController.carouselController,
                  items: [
                    for (int firstAidNumber = 1;
                        firstAidNumber <= 17;
                        firstAidNumber++)
                      ClickableLabeledImage(
                        img: getFirstAidTipImage(firstAidNumber),
                        label: 'firstAidTips$firstAidNumber'.tr,
                        onPressed: () {
                          Get.to(
                            FirstAidTipsDetailsPage(
                              imgPath: getFirstAidDetailsPath(
                                AppInit.currentDeviceLanguage,
                                firstAidNumber,
                              ),
                            ),
                          );
                        },
                      ),
                  ],
                  options: CarouselOptions(
                    autoPlay: true,
                    aspectRatio: 2.0,
                    enlargeCenterPage: true,
                    enlargeStrategy: CenterPageEnlargeStrategy.height,
                  ),
                ),
                TextHeader(headerText: 'services'.tr),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      RoundedImageElevatedButton(
                        buttonText: 'normalRequest'.tr,
                        imagePath: kAmbulanceImage,
                        onPressed: () {},
                      ),
                      const Spacer(),
                      RoundedImageElevatedButton(
                        buttonText: 'sosRequest'.tr,
                        imagePath: kSosImage,
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
                TextHeaderWithButton(
                  headerText: 'recentRequests'.tr,
                  onPressed: () {},
                  buttonText: 'viewAll'.tr,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
