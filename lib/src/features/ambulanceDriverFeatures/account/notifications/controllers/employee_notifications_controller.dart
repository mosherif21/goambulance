import 'package:get/get.dart';
import 'package:goambulance/firebase_files/firebase_ambulance_employee_access.dart';
import 'package:goambulance/src/constants/enums.dart';
import 'package:goambulance/src/features/account/components/models.dart';
import 'package:goambulance/src/features/ambulanceDriverFeatures/home_screen/controllers/employee_home_screen_controller.dart';
import 'package:goambulance/src/general/general_functions.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class EmployeeNotificationController extends GetxController {
  static EmployeeNotificationController get instance => Get.find();

  final notificationList = <NotificationItem>[].obs;

  late final FirebaseAmbulanceEmployeeDataAccess firebaseEmployeesDataAccess;
  final notificationLoaded = false.obs;
  final notificationsRefreshController =
      RefreshController(initialRefresh: false);
  @override
  void onInit() async {
    firebaseEmployeesDataAccess = FirebaseAmbulanceEmployeeDataAccess.instance;
    super.onInit();
  }

  @override
  void onReady() async {
    loadNotifications();
  }

  void loadNotifications() async {
    final notifications = await firebaseEmployeesDataAccess.getNotifications();
    if (notifications != null) {
      notificationList.value = notifications;
      notificationLoaded.value = true;
      if (Get.isRegistered<EmployeeHomeScreenController>()) {
        if (EmployeeHomeScreenController.instance.notificationsCount.value !=
            0) {
          await firebaseEmployeesDataAccess.resetNotificationCount();
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
