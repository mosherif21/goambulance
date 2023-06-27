import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../notifications/screens/notifications_screen.dart';

class EmployeeNotificationsButton extends StatelessWidget {
  const EmployeeNotificationsButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      shape: const CircleBorder(),
      color: Colors.white,
      child: InkWell(
        customBorder: const CircleBorder(),
        splashFactory: InkSparkle.splashFactory,
        child: const Padding(
          padding: EdgeInsets.all(15),
          child: badges.Badge(
            badgeContent: Text('3'),
            child: Icon(
              Icons.notifications,
              size: 30,
            ),
          ),
        ),
        onTap: () => Get.to(() => const NotificationsScreen()),
      ),
    );
  }
}
