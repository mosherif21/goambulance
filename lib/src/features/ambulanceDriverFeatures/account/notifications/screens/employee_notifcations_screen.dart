import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/features/notifications/components/notification_Item.dart';
import 'package:goambulance/src/general/common_widgets/back_button.dart';

import '../../../../account/components/addresses/loading_addresses.dart';
import '../../../../notifications/components/no_notifications.dart';
import '../controllers/employee_notifications_controller.dart';

class EmployeeNotificationsScreen extends StatelessWidget {
  const EmployeeNotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EmployeeNotificationController());
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: const RegularBackButton(padding: 0),
        title: AutoSizeText(
          'notifications'.tr,
          maxLines: 1,
        ),
        titleTextStyle: const TextStyle(
            fontSize: 25, fontWeight: FontWeight.w600, color: Colors.black),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: StretchingOverscrollIndicator(
            axisDirection: AxisDirection.down,
            child: SingleChildScrollView(
              child: Obx(
                () => SingleChildScrollView(
                  child: !controller.notificationLoaded.value
                      ? const LoadingAddresses()
                      : controller.notificationList.isNotEmpty
                          ? Column(
                              children: [
                                for (var notificationItem
                                    in controller.notificationList)
                                  NotiItem(notificationItem: notificationItem),
                              ],
                            )
                          : const NoNotifications(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
