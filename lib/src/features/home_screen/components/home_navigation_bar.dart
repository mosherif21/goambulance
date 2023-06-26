import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:floating_draggable_widget/floating_draggable_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/constants/assets_strings.dart';
import 'package:goambulance/src/general/general_functions.dart';
import 'package:lottie/lottie.dart';

import '../../account/screens/account_screen.dart';
import '../../home_dashboard/screens/home_dashboard.dart';
import '../../requests/screens/previous_requests_page.dart';
import '../controllers/home_screen_controller.dart';

class HomeNavigationBar extends StatelessWidget {
  const HomeNavigationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeScreenController = HomeScreenController.instance;
    final screenHeight = getScreenHeight(context);
    return FloatingDraggableWidget(
      floatingWidget: GestureDetector(
        child: Transform.scale(
          scale: 1.5,
          child: Lottie.asset(
            kChatBotAnim,
            fit: BoxFit.contain,
            repeat: true,
          ),
        ),
      ),
      autoAlign: true,
      floatingWidgetHeight: 130,
      floatingWidgetWidth: 130,
      dx: 0,
      dy: screenHeight * 0.75,
      mainScreenWidget: Scaffold(
        body: Obx(
          () => homeScreenController.navBarIndex.value == 0
              ? const HomeDashBoard()
              : homeScreenController.navBarIndex.value == 1
                  ? const PreviousRequestsPage()
                  : const AccountScreen(),
        ),
        backgroundColor: Colors.grey.shade100,
        bottomNavigationBar: Container(
          padding: const EdgeInsets.only(left: 25, right: 25, bottom: 15),
          child: Obx(
            () => CustomNavigationBar(
              iconSize: 30.0,
              selectedColor: Colors.black,
              strokeColor: Colors.black38,
              unSelectedColor: Colors.grey[600],
              backgroundColor: Colors.white,
              elevation: 5,
              borderRadius: const Radius.circular(20.0),
              items: [
                CustomNavigationBarItem(
                  icon: const Icon(Icons.home_filled),
                ),
                CustomNavigationBarItem(
                  icon: const Icon(Icons.history_outlined),
                ),
                CustomNavigationBarItem(
                  icon: const Icon(Icons.person),
                ),
              ],
              currentIndex: homeScreenController.navBarIndex.value,
              onTap: homeScreenController.navigationBarOnTap,
              isFloating: true,
            ),
          ),
        ),
      ),
    );
  }
}
