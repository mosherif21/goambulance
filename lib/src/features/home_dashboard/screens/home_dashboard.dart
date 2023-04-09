import 'package:animations/animations.dart';
import 'package:badges/badges.dart' as badges;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/features/first_aid/controllers/first_aid_assets.dart';
import 'package:goambulance/src/features/first_aid/screens/first_aid_screen.dart';
import 'package:goambulance/src/features/home_screen/controllers/home_screen_controller.dart';
import 'package:goambulance/src/general/common_widgets/text_header.dart';

import '../../../constants/assets_strings.dart';
import '../../../general/common_widgets/labeled_image.dart';
import '../../../general/common_widgets/rounded_elevated_button.dart';
import '../../../general/common_widgets/text_header_with_button.dart';
import '../../first_aid/components/first_aid_tips_details_page.dart';

class HomeDashBoard extends StatelessWidget {
  const HomeDashBoard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeScreenController = HomeScreenController.instance;
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: StretchingOverscrollIndicator(
          axisDirection: AxisDirection.down,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
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
                            splashRadius: 25,
                            onPressed: () =>
                                homeScreenController.toggleDrawer(),
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
                        transition: Transition.noTransition),
                    buttonText: 'viewAll'.tr,
                  ),
                  CarouselSlider(
                    carouselController: homeScreenController.carouselController,
                    items: [
                      for (int firstAidNumber = 1;
                          firstAidNumber <= 17;
                          firstAidNumber++)
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: OpenContainer(
                            useRootNavigator: true,
                            closedElevation: 0,
                            openElevation: 0,
                            closedBuilder: (context, action) =>
                                clickableLabeledImage(
                              img: getFirstAidTipImage(firstAidNumber),
                              label: 'firstAidTips$firstAidNumber'.tr,
                            ),
                            openBuilder: (context, action) =>
                                FirstAidTipsDetailsPage(
                              imgPath: getFirstAidDetailsPath(firstAidNumber),
                            ),
                          ),
                        ),
                    ],
                    options: CarouselOptions(
                      autoPlay: true,
                      aspectRatio: 2.0,
                      enlargeCenterPage: true,
                      enlargeStrategy: CenterPageEnlargeStrategy.height,
                    ),
                  ),
                  TextHeader(headerText: 'services'.tr, fontSize: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: RoundedImageElevatedButton(
                            buttonText: 'normalRequest'.tr,
                            imagePath: kAmbulanceImage,
                            onPressed: () {},
                          ),
                        ),
                        const Spacer(),
                        Expanded(
                          flex: 3,
                          child: RoundedImageElevatedButton(
                            buttonText: 'sosRequest'.tr,
                            imagePath: kSosImage,
                            onPressed: () {},
                          ),
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
      ),
    );
  }
}
