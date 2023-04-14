import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:goambulance/src/features/home_screen/controllers/home_screen_controller.dart';

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
        badges.Badge(
          onTap: () {},
          badgeContent: const Text('3'),
          child: const Icon(
            Icons.notifications,
            size: 30,
          ),
        ),
      ],
    );
  }
}
