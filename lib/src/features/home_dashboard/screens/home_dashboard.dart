import 'package:badges/badges.dart' as badges;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/features/home_screen/components/first_aid_tips_page.dart';
import 'package:goambulance/src/features/home_screen/controllers/home_screen_controller.dart';
import 'package:goambulance/src/general/common_widgets/text_header.dart';

import '../../../constants/assets_strings.dart';
import '../../../general/common_widgets/clickable_labeled_image.dart';
import '../../../general/common_widgets/rounded_elevated_button.dart';
import '../../../general/common_widgets/text_header_with_button.dart';

class HomeDashBoard extends StatelessWidget {
  const HomeDashBoard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeScreenController = HomeScreenController.instance;
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          child: Center(
            child: Column(
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        ValueListenableBuilder(
                            valueListenable: homeScreenController
                                .zoomDrawerController.stateNotifier!,
                            builder: (BuildContext context,
                                DrawerState drawerState, Widget? child) {
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
                            }),
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
                      onPressed: () {},
                      buttonText: 'viewAll'.tr,
                    ),
                    CarouselSlider(
                      carouselController:
                          homeScreenController.carouselController,
                      items: [
                        for (String img in homeScreenController.imgList)
                          ClickableLabeledImage(
                            img: img,
                            label:
                                'firstAidTips${homeScreenController.imgList.indexOf(img) + 1}'
                                    .tr,
                            onPressed: () {
                              Get.to(FirstAidTipsPage(imgPath: img));
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
                    const SizedBox(height: 15),
                    TextHeader(
                      headerText: 'services'.tr,
                    ),
                    Row(
                      children: [
                        RoundedElevatedButton(
                          buttonText: 'normalRequest'.tr,
                          imagePath: kAmbulanceImage,
                          onPressed: () {},
                        ),
                        const Spacer(),
                        RoundedElevatedButton(
                          buttonText: 'sosRequest'.tr,
                          imagePath: 'assets/images/sos.png',
                          onPressed: () {},
                        ),
                      ],
                    ),
                    TextHeaderWithButton(
                      headerText: 'recentRequests'.tr,
                      onPressed: () {},
                      buttonText: 'viewAll'.tr,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
