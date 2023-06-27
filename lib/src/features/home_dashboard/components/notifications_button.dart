import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../general/general_functions.dart';
import '../../notifications/screens/notifications_screen.dart';

class NotificationsButton extends StatelessWidget {
  const NotificationsButton({Key? key, required this.notificationsCount})
      : super(key: key);
  final int notificationsCount;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: EdgeInsets.only(
        left: isLangEnglish() ? 0 : 8,
        right: isLangEnglish() ? 8 : 0,
      ),
      child: GestureDetector(
        onTap: () => Get.to(() => const NotificationsScreen()),
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
    );
  }
}
