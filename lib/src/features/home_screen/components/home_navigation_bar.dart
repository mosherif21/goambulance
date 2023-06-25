import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/colors.dart';
import '../../account/screens/account_screen.dart';
import '../../chat_bot/screens/chat_bot_screen.dart';
import '../../home_dashboard/screens/home_dashboard.dart';
import '../../requests/screens/previous_requests_page.dart';
import '../controllers/home_screen_controller.dart';

class HomeNavigationBar extends StatelessWidget {
  const HomeNavigationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeScreenController = HomeScreenController.instance;
    return Obx(
      () => Scaffold(
        body: homeScreenController.navBarIndex.value == 0
            ? const HomeDashBoard()
            : homeScreenController.navBarIndex.value == 1
                ? const ChatBotScreen()
                : homeScreenController.navBarIndex.value == 2
                    ? const PreviousRequestsPage()
                    : const AccountScreen(),
        backgroundColor: Colors.grey.shade100,
        bottomNavigationBar: Container(
          padding: const EdgeInsets.only(bottom: 15),
          child: CustomNavigationBar(
            iconSize: 30.0,
            selectedColor: kDefaultColor,
            strokeColor: kDefaultColorLessShade,
            unSelectedColor: Colors.grey[600],
            backgroundColor: Colors.white,
            elevation: 5,
            borderRadius: const Radius.circular(20.0),
            items: [
              CustomNavigationBarItem(
                icon: const Icon(Icons.home_filled),
              ),
              CustomNavigationBarItem(
                icon: const Icon(Icons.chat),
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
    );
  }
}
