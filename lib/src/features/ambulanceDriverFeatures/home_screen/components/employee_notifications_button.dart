import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../general/general_functions.dart';
import '../../../notifications/screens/notifications_screen.dart';

class EmployeeNotificationsButton extends StatelessWidget {
  const EmployeeNotificationsButton({Key? key}) : super(key: key);

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
