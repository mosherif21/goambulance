import 'package:get/get.dart';
import 'package:goambulance/src/constants/enums.dart';
import 'package:goambulance/src/features/account/components/models.dart';
import 'package:goambulance/src/features/home_screen/controllers/home_screen_controller.dart';
import 'package:goambulance/src/general/general_functions.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../firebase_files/firebase_patient_access.dart';

class NotificationController extends GetxController {
  static NotificationController get instance => Get.find();

  final notificationList = <NotificationItem>[].obs;

  late final FirebasePatientDataAccess firebasePatientDataAccess;
  final notificationLoaded = false.obs;
  final notificationsRefreshController =
      RefreshController(initialRefresh: false);
  @override
  void onInit() async {
    firebasePatientDataAccess = FirebasePatientDataAccess.instance;
    super.onInit();
  }

  @override
  void onReady() async {
    loadNotifications();
  }

  void loadNotifications() async {
    final notifications = await firebasePatientDataAccess.getNotifications();
    if (notifications != null) {
      notificationList.value = notifications;
      notificationLoaded.value = true;
      if (Get.isRegistered<HomeScreenController>()) {
        if (HomeScreenController.instance.notificationsCount.value != 0) {
          await firebasePatientDataAccess.resetNotificationCount();
        }
      }
    } else {
      showSnackBar(text: 'errorOccurred'.tr, snackBarType: SnackBarType.error);
    }
  }

  @override
  void onClose() {
    notificationsRefreshController.dispose();
    super.onClose();
  }

  void onRefresh() {
    notificationLoaded.value = false;
    loadNotifications();
    notificationsRefreshController.refreshToIdle();
    notificationsRefreshController.resetNoData();
  }
}
