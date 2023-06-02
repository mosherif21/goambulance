import 'package:animations/animations.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/features/first_aid/controllers/first_aid_assets.dart';
import 'package:goambulance/src/features/first_aid/screens/first_aid_screen.dart';
import 'package:goambulance/src/features/home_screen/controllers/home_screen_controller.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../general/common_widgets/labeled_image.dart';
import '../../../general/common_widgets/text_header.dart';
import '../../../general/common_widgets/text_header_with_button.dart';
import '../../../general/general_functions.dart';
import '../../first_aid/components/first_aid_tips_details_page.dart';
import '../components/notifications_button.dart';
import '../components/services_buttons.dart';
import '../components/services_page.dart';

final List<String> imgList = [
  'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
  'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
  'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
  'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
];

class HomeDashBoard extends StatelessWidget {
  const HomeDashBoard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //var current = 0;
    final homeScreenController = HomeScreenController.instance;
    final controller = PageController(viewportFraction: 0.8, keepPage: true);
    // final controller2 = PageController(viewportFraction: 0.9, keepPage: true);
    final sponsorPages = List.generate(
      16,
      (index) => Container(
        color: Colors.transparent,
        padding: const EdgeInsets.all(15),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: OpenContainer(
            useRootNavigator: true,
            closedElevation: 0,
            openElevation: 0,
            closedBuilder: (context, action) => Container(
                color: Colors.transparent,
                padding: const EdgeInsets.all(15),
                child: Image.asset(getFirstAidTipImage(index + 1),
                    fit: BoxFit.contain, width: 1000.0)),
            openBuilder: (context, action) => FirstAidTipsDetailsPage(
              imgPath: getFirstAidDetailsPath(index + 1),
            ),
          ),
        ),
      ),
    );

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
        backgroundColor: Colors.grey.shade100,
      ),
      backgroundColor: Colors.grey.shade100,
      body: StretchingOverscrollIndicator(
        axisDirection: AxisDirection.down,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: AnimationLimiter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: AnimationConfiguration.toStaggeredList(
                  duration: const Duration(milliseconds: 375),
                  childAnimationBuilder: (widget) => SlideAnimation(
                    horizontalOffset: 50.0,
                    child: FadeInAnimation(
                      child: widget,
                    ),
                  ),
                  children: [
                    TextHeaderWithButton(
                      headerText: 'firstAidTips'.tr,
                      onPressed: () => Get.to(
                        () => const FirstAidScreen(),
                        transition: getPageTransition(),
                      ),
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
                                imgPath: getFirstAidDetailsPath(firstAidNumber),
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
                      onPressed: () => Get.to(
                        () => const ServicesScreen(),
                        transition: getPageTransition(),
                      ),
                      buttonText: 'viewAll'.tr,
                    ),
                    const ServicesButtons(),
                    const SizedBox(height: 15),
                    TextHeader(
                      headerText: 'sponsors'.tr,
                      fontSize: 24,
                    ),
                    SizedBox(
                      height: 200,
                      child: PageView.builder(
                        controller: controller,
                        //itemCount: pages.length,
                        itemBuilder: (_, index) {
                          return sponsorPages[index % sponsorPages.length];
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Align(
                        alignment: Alignment.center,
                        child: SmoothPageIndicator(
                          controller: controller,
                          count: 6,
                          effect: const WormEffect(
                            dotHeight: 12,
                            dotWidth: 12,
                            activeDotColor: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    // CarouselSlider(
                    //   carouselController:
                    //       homeScreenController.carouselController,
                    //   items: [
                    //     for (int firstAidNumber = 1;
                    //         firstAidNumber <= 17;
                    //         firstAidNumber++)
                    //       Padding(
                    //         padding: const EdgeInsets.all(5.0),
                    //         child: OpenContainer(
                    //           useRootNavigator: true,
                    //           closedElevation: 0,
                    //           openElevation: 0,
                    //           closedBuilder: (context, action) =>
                    //               clickableLabeledImage(
                    //             img: getFirstAidTipImage(firstAidNumber),
                    //             label: 'firstAidTips$firstAidNumber'.tr,
                    //           ),
                    //           openBuilder: (context, action) =>
                    //               FirstAidTipsDetailsPage(
                    //             imgPath:
                    //                 getFirstAidDetailsPath(firstAidNumber),
                    //           ),
                    //         ),
                    //       ),
                    //   ],
                    //   options: CarouselOptions(
                    //       autoPlay: false,
                    //       aspectRatio: 2.0,
                    //       enlargeCenterPage: true,
                    //       enlargeStrategy: CenterPageEnlargeStrategy.zoom,
                    //       onPageChanged: (index, reason) {
                    //         current = index;
                    //       }),
                    // ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: imgList.asMap().entries.map((entry) {
                    //     return GestureDetector(
                    //       onTap: () => homeScreenController.carouselController
                    //           .animateToPage(entry.key),
                    //       child: Container(
                    //         width: 12.0,
                    //         height: 12.0,
                    //         margin: const EdgeInsets.symmetric(
                    //             vertical: 8.0, horizontal: 4.0),
                    //         decoration: BoxDecoration(
                    //           shape: BoxShape.circle,
                    //           color: (Theme.of(context).brightness ==
                    //                       Brightness.dark
                    //                   ? Colors.white
                    //                   : Colors.black)
                    //               .withOpacity(
                    //                   current == entry.key ? 0.9 : 0.4),
                    //         ),
                    //       ),
                    //     );
                    //   }).toList(),
                    // ),
                    const SizedBox(height: 20),
                    SizedBox(height: screenHeight * 0.1)
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
