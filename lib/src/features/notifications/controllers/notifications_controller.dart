import 'package:get/get.dart';
import 'package:goambulance/src/features/account/components/models.dart';

import '../../../../firebase_files/firebase_patient_access.dart';

class NotificationController extends GetxController {
  static NotificationController get instance => Get.find();

  var notificationList = <NotificationItem>[].obs;

  late final FirebasePatientDataAccess firebasePatientDataAccess;
  final notificationLoaded = false.obs;

  @override
  void onInit() async {
    firebasePatientDataAccess = FirebasePatientDataAccess.instance;
    loadNotifications();
    // firebasePatientDataAccess.updateNotification();
    super.onInit();
  }

  @override
  void onReady() async {}

  void loadNotifications() async {
    notificationList.value =
        (await firebasePatientDataAccess.getNotifications())!;
    if (notificationList.isNotEmpty) {
      notificationLoaded.value = true;
    }
  }

  // removeAddress({required AddressItem addressItem}) async {
  //   showLoadingScreen();
  //   final addressDocumentId = firebasePatientDataAccess.firestoreUserRef
  //       .collection('addresses')
  //       .doc(addressItem.addressId);
  //   final functionStatus = await firebasePatientDataAccess.deleteDocument(
  //       documentRef: addressDocumentId);
  //   hideLoadingScreen();
  //   if (functionStatus == FunctionStatus.success) {
  //     addressesList.remove(addressItem);
  //     if (addressesList.length == 1 && !addressesList.first.isPrimary) {
  //       updatePrimary(addressItem: addressesList.first);
  //     }
  //   } else if (functionStatus == FunctionStatus.failure) {
  //     showSnackBar(
  //         text: 'addressDeletionFailed'.tr, snackBarType: SnackBarType.error);
  //   }
  // }

  @override
  void onClose() {
    super.onClose();
  }
}
