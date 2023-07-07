import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/features/notifications/components/no_notifications.dart';
import 'package:goambulance/src/features/notifications/controllers/notifications_controller.dart';
import 'package:goambulance/src/general/common_widgets/back_button.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../general/general_functions.dart';
import '../../account/components/addresses/loading_addresses.dart';
import '../components/notification_Item.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NotificationController());
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
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: StretchingOverscrollIndicator(
            axisDirection: AxisDirection.down,
            child: Obx(
              () => !controller.notificationLoaded.value
                  ? const LoadingAddresses()
                  : RefreshConfiguration(
                      headerTriggerDistance: 60,
                      maxOverScrollExtent: 20,
                      enableLoadingWhenFailed: true,
                      hideFooterWhenNotFull: true,
                      child: AnimationLimiter(
                        child: SmartRefresher(
                          enablePullDown: true,
                          header: ClassicHeader(
                            completeDuration: const Duration(milliseconds: 0),
                            releaseText: 'releaseToRefresh'.tr,
                            refreshingText: 'refreshing'.tr,
                            idleText: 'pullToRefresh'.tr,
                            completeText: 'refreshCompleted'.tr,
                            iconPos: isLangEnglish()
                                ? IconPosition.left
                                : IconPosition.right,
                            textStyle: const TextStyle(color: Colors.grey),
                            failedIcon:
                                const Icon(Icons.error, color: Colors.grey),
                            completeIcon:
                                const Icon(Icons.done, color: Colors.grey),
                            idleIcon: const Icon(Icons.arrow_downward,
                                color: Colors.grey),
                            releaseIcon:
                                const Icon(Icons.refresh, color: Colors.grey),
                          ),
                          controller: controller.notificationsRefreshController,
                          onRefresh: () => controller.onRefresh(),
                          child: ListView.builder(
                            itemBuilder: (_, int index) =>
                                controller.notificationList.isNotEmpty
                                    ? NotiItem(
                                        notificationItem:
                                            controller.notificationList[index])
                                    : const NoNotifications(),
                            itemCount: controller.notificationList.isNotEmpty
                                ? controller.notificationList.length
                                : 1,
                          ),
                        ),
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
