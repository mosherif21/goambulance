import 'package:get/get.dart';
import 'package:goambulance/src/constants/enums.dart';
import 'package:goambulance/src/features/account/components/models.dart';
import 'package:goambulance/src/features/home_screen/controllers/home_screen_controller.dart';
import 'package:goambulance/src/general/general_functions.dart';

import '../../../../firebase_files/firebase_patient_access.dart';

class NotificationController extends GetxController {
  static NotificationController get instance => Get.find();

  final notificationList = <NotificationItem>[].obs;

  late final FirebasePatientDataAccess firebasePatientDataAccess;
  final notificationLoaded = false.obs;

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
    //check enaha mesh null 3shan lw 7sal error aw net mesh sh8al htrg3 null
    final notifications = await firebasePatientDataAccess.getNotifications();
    if (notifications != null) {
      notificationList.value = notifications;
      /*fe game3 el a7wal talama 3mal load men 8er ma yrg3 null y3ny mfesh error yeb2a hya loaded 5las 7ata lw kant empty we hwa m3ndo4 notifications
      momkn lw b3d el load el notificationList list fadya yetl3lo ay klam fe el UI eno m3ndo4 notifications asln*/
      //if (notificationList.isNotEmpty) {
      notificationLoaded.value = true;
      // }
      /*  ba3d ma 3malt load lel notifications we m7sal4 error
      yeb2a sa3tha h5aly el unseenCount be 0 3shan hwa 5las 4af el notifications we el garaz ely bara yeb2a m3lehosh rakam
      bs ha check 3al notifications count ely fe el home screen controller 3shan lw already be zero yeb2a mlhash lazma a reset*/
      if (Get.isRegistered<HomeScreenController>()) {
        if (HomeScreenController.instance.notificationsCount.value != 0) {
          await firebasePatientDataAccess.resetNotificationCount();
        }
      }
    } else {
      showSnackBar(text: 'errorOccurred'.tr, snackBarType: SnackBarType.error);
    }
  }

  // @override
  // void onClose() {
  //   super.onClose();
  // }
}
