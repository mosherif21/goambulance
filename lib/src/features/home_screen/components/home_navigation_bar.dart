import 'package:animations/animations.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:floating_draggable_widget/floating_draggable_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/constants/assets_strings.dart';
import 'package:goambulance/src/features/chat_bot/screens/chat_bot_screen.dart';
import 'package:goambulance/src/general/app_init.dart';
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
    final screenWidth = getScreenWidth(context);
    return FloatingDraggableWidget(
      floatingWidget: OpenContainer(
        useRootNavigator: true,
        closedElevation: 0,
        openElevation: 0,
        closedColor: Colors.transparent,
        openColor: Colors.transparent,
        closedBuilder: (context, action) => Transform.scale(
          scale: 1.5,
          child: Lottie.asset(
            kChatBotAnim,
            fit: BoxFit.contain,
            repeat: true,
          ),
        ),
        openBuilder: (context, action) => const ChatBotScreen(),
      ),
      autoAlign: true,
      floatingWidgetHeight: 130,
      floatingWidgetWidth: AppInit.isWeb ? 130 : screenWidth * 0.3,
      dx: AppInit.isWeb ? 0.0 : screenWidth * 0.72,
      dy: screenHeight * 0.74,
      mainScreenWidget: Scaffold(
        body: Stack(children: [
          Obx(
            () => homeScreenController.navBarIndex.value == 0
                ? const HomeDashBoard()
                : homeScreenController.navBarIndex.value == 1
                    ? const PreviousRequestsPage()
                    : const AccountScreen(),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(20),
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
        ]),
        backgroundColor: Colors.grey.shade100,
      ),
    );
  }
}
