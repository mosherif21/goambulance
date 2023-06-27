import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../notifications/screens/notifications_screen.dart';

class EmployeeNotificationsButton extends StatelessWidget {
  const EmployeeNotificationsButton(
      {Key? key, required this.notificationsCount})
      : super(key: key);
  final int notificationsCount;
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      shape: const CircleBorder(),
      color: Colors.white,
      child: InkWell(
        customBorder: const CircleBorder(),
        splashFactory: InkSparkle.splashFactory,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: notificationsCount != 0
              ? badges.Badge(
                  badgeContent: Text(notificationsCount.toString()),
                  child: const Icon(
                    Icons.notifications,
                    size: 30,
                  ),
                )
              : const Icon(
                  Icons.notifications,
                  size: 30,
                ),
        ),
        onTap: () => Get.to(() => const NotificationsScreen()),
      ),
    );
  }
}
