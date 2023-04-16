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
import '../../../general/general_functions.dart';
import '../../first_aid/components/first_aid_tips_details_page.dart';
import '../../notifications/screens/notifications_screen.dart';
import '../components/no_requests_history.dart';

class HomeDashBoard extends StatelessWidget {
  const HomeDashBoard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeScreenController = HomeScreenController.instance;
    final screenHeight = getScreenHeight(context);
    return Scaffold(
      appBar: AppBar(
        leading: ValueListenableBuilder(
          valueListenable:
              homeScreenController.zoomDrawerController.stateNotifier!,
          builder:
              (BuildContext context, DrawerState drawerState, Widget? child) {
            return IconButton(
              splashRadius: 25,
              onPressed: () => homeScreenController.toggleDrawer(),
              icon: Icon(
                homeScreenController.isDrawerOpen(drawerState)
                    ? Icons.close
                    : Icons.menu_outlined,
                size: 30,
              ),
            );
          },
        ),
        actions: [
          Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () async =>
                  await Get.to(() => const NotificationsScreen()),
              child: const badges.Badge(
                badgeContent: Text('3'),
                child: Icon(
                  Icons.notifications,
                  size: 30,
                ),
              ),
            ),
          ),
        ],
        elevation: 0,
        scrolledUnderElevation: 5,
        backgroundColor: Colors.grey.shade100,
      ),
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          child: Column(
            children: [
              //HomeAppBar(homeScreenController: homeScreenController),
              Expanded(
                child: StretchingOverscrollIndicator(
                  axisDirection: AxisDirection.down,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextHeaderWithButton(
                          headerText: 'firstAidTips'.tr,
                          onPressed: () => Get.to(() => const FirstAidScreen(),
                              transition: Transition.noTransition),
                          buttonText: 'viewAll'.tr,
                        ),
                        CarouselSlider(
                          carouselController:
                              homeScreenController.carouselController,
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
                                    imgPath:
                                        getFirstAidDetailsPath(firstAidNumber),
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
                        const SizedBox(height: 15),
                        TextHeader(headerText: 'services'.tr, fontSize: 24),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: isUserCritical() ? 3 : 1,
                                child: RoundedImageElevatedButton(
                                  buttonText: 'normalRequest'.tr,
                                  imagePath: kAmbulanceImage,
                                  onPressed: () {},
                                ),
                              ),
                              const Spacer(),
                              if (isUserCritical())
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
                        const SizedBox(height: 15),
                        TextHeaderWithButton(
                          headerText: 'recentRequests'.tr,
                          onPressed: () => homeScreenController
                              .homeBottomTabController
                              .jumpToTab(2),
                          buttonText: 'viewAll'.tr,
                        ),
                        const NoRequestsHistory(),
                        SizedBox(height: screenHeight * 0.1)
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
