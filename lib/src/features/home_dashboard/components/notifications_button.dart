import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../notifications/screens/notifications_screen.dart';

class NotificationsButton extends StatelessWidget {
  const NotificationsButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
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
    );
  }
}
