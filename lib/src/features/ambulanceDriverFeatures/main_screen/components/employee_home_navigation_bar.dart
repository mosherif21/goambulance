import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../account/screens/employee_account_screen.dart';
import '../../home_screen/screens/employee_home_screen.dart';
import '../controllers/employee_main_screen_controller.dart';

class EmployeeHomeNavigationBar extends StatelessWidget {
  const EmployeeHomeNavigationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mainScreenController = EmployeeMainScreenController.instance;
    return Scaffold(
      body: Stack(children: [
        PageView.builder(
          physics: const NeverScrollableScrollPhysics(),
          controller: mainScreenController.pageController,
          itemCount: 2,
          itemBuilder: (BuildContext context, int index) {
            switch (index) {
              case 0:
                return const EmployeeHomeScreen();
              case 1:
                return const EmployeeAccountScreen();
              default:
                return const SizedBox.shrink();
            }
          },
        ),
        Positioned(
          bottom: 0,
          right: 0,
          left: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
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
                currentIndex: mainScreenController.navBarIndex.value,
                onTap: mainScreenController.navigationBarOnTap,
                isFloating: true,
              ),
            ),
          ),
        )
      ]),
    );
  }
}
