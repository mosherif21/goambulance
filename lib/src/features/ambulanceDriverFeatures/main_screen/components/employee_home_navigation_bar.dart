import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../account/screens/employee_account_screen.dart';
import '../controllers/employee_home_screen_controller.dart';

class EmployeeHomeNavigationBar extends StatelessWidget {
  const EmployeeHomeNavigationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeScreenController = EmployeeHomeScreenController.instance;
    return Scaffold(
      body: Stack(children: [
        Obx(
          () => homeScreenController.navBarIndex.value == 0
              ? const SizedBox.expand()
              : const EmployeeAccountScreen(),
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
    );
  }
}
