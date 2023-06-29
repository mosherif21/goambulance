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
      margin: EdgeInsets.only(
        left: isLangEnglish() ? 0 : 8,
        right: isLangEnglish() ? 8 : 0,
      ),
      child: Material(
        elevation: 0,
        shape: const CircleBorder(),
        color: Colors.transparent,
        child: InkWell(
          customBorder: const CircleBorder(),
          splashFactory: InkSparkle.splashFactory,
          child: Padding(
            padding: const EdgeInsets.all(10),
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
          onTap: () {
            Get.to(
              () => const NotificationsScreen(),
            );
          },
        ),
      ),
    );
  }
}
