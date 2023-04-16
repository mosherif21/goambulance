import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/features/home_screen/controllers/home_screen_controller.dart';

import '../../notifications/screens/notifications_screen.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({Key? key, required this.homeScreenController})
      : super(key: key);
  final HomeScreenController homeScreenController;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ValueListenableBuilder(
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
        const Spacer(),
        Container(
          margin: const EdgeInsets.only(right: 8),
          child: GestureDetector(
            onTap: () async => await Get.to(() => const NotificationsScreen()),
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
    );
  }
}
