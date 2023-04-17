import 'package:animations/animations.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/features/first_aid/controllers/first_aid_assets.dart';
import 'package:goambulance/src/features/first_aid/screens/first_aid_screen.dart';
import 'package:goambulance/src/features/home_screen/controllers/home_screen_controller.dart';

import '../../../general/common_widgets/labeled_image.dart';
import '../../../general/common_widgets/text_header_with_button.dart';
import '../../../general/general_functions.dart';
import '../../first_aid/components/first_aid_tips_details_page.dart';
import '../components/no_requests_history.dart';
import '../components/notifications_button.dart';
import '../components/services_buttons.dart';
import '../components/services_page.dart';

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
        actions: const [NotificationsButton()],
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
                            aspectRatio: 2.2,
                            enlargeCenterPage: true,
                            enlargeStrategy: CenterPageEnlargeStrategy.height,
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextHeaderWithButton(
                          headerText: 'services'.tr,
                          onPressed: () async =>
                              await Get.to(() => const ServicesScreen()),
                          buttonText: 'viewAll'.tr,
                        ),
                        const ServicesButtons(),
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
