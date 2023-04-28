import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:get/get.dart';
import 'package:goambulance/authentication/authentication_repository.dart';
import 'package:goambulance/firebase_files/firebase_patient_access.dart';
import 'package:goambulance/src/constants/enums.dart';

import '../../../general/common_widgets/regular_bottom_sheet.dart';
import '../../../general/general_functions.dart';

class SosMessageController extends GetxController {
  static SosMessageController get instance => Get.find();

  //vars
  final contactName = ''.obs;
  final phoneNumber = ''.obs;
  final highlightSosMessage = false.obs;
  final sosMessageDataLoaded = false.obs;
  String sosMessage = '';
  final contactsList = <ContactItem>[].obs;
  late final FirebasePatientDataAccess firebasePatientDataAccess;
  late final AuthenticationRepository authRepo;

  //controllers
  final contactNameTextController = TextEditingController();
  final sosMessageController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    firebasePatientDataAccess = FirebasePatientDataAccess.instance;
    authRepo = AuthenticationRepository.instance;
  }

  @override
  void onReady() async {
    super.onReady();
    contactsList.value = await firebasePatientDataAccess.getEmergencyContacts();
    sosMessage = authRepo.userInfo!.sosMessage;
    sosMessageController.text = sosMessage;
    sosMessageDataLoaded.value = true;
    sosMessageController.addListener(() {
      if (sosMessageController.text.trim().isNotEmpty) {
        highlightSosMessage.value = false;
      }
      sosMessage = sosMessageController.text.trim();
    });
    contactNameTextController.addListener(() {
      contactName.value = contactNameTextController.text.trim();
    });
  }

  addContact() async {
    showLoadingScreen();
    final contactItem = await firebasePatientDataAccess.addEmergencyContact(
      contactName: contactName.value,
      contactNumber: phoneNumber.value,
    );
    hideLoadingScreen();
    if (contactItem != null) {
      RegularBottomSheet.hideBottomSheet();
      contactsList.add(contactItem);
      contactNameTextController.clear();
    } else {
      showSnackBar(
          text: 'addingEmergencyContactFailed'.tr,
          snackBarType: SnackBarType.error);
    }
  }

  deleteContact({required ContactItem contactItem}) async {
    showLoadingScreen();
    final contactDocumentId = firebasePatientDataAccess.firestoreUserRef
        .collection('emergencyContacts')
        .doc(contactItem.contactDocumentId);
    final functionStatus = await firebasePatientDataAccess.deleteDocument(
        documentRef: contactDocumentId);
    hideLoadingScreen();
    if (functionStatus == FunctionStatus.success) {
      contactsList.remove(contactItem);
    } else if (functionStatus == FunctionStatus.failure) {
      showSnackBar(
          text: 'deletingEmergencyContactFailed'.tr,
          snackBarType: SnackBarType.error);
    }
  }

  void saveSosMessage() async {
    if (sosMessage.isNotEmpty) {
      showLoadingScreen();
      final functionStatus = await firebasePatientDataAccess.saveSosMessage(
          sosMessage: sosMessage);
      authRepo.userInfo!.sosMessage = sosMessage;
      hideLoadingScreen();
      if (functionStatus == FunctionStatus.success) {
        showSnackBar(
            text: 'sosMessageSaved'.tr, snackBarType: SnackBarType.success);
      } else if (functionStatus == FunctionStatus.failure) {
        showSnackBar(
            text: 'savingSosMessageFailed'.tr,
            snackBarType: SnackBarType.error);
      }
    } else {
      highlightSosMessage.value = true;
      showSnackBar(text: 'requiredFields'.tr, snackBarType: SnackBarType.error);
    }
  }

  void sendSosMessage() async {
    highlightSosMessage.value = sosMessage.isEmpty;
    if (!highlightSosMessage.value && contactsList.isNotEmpty) {
      showLoadingScreen();
      final contactNumbersList = <String>[];
      for (var contact in contactsList) {
        contactNumbersList.add(contact.contactNumber);
      }
      try {
        await sendSMS(message: sosMessage, recipients: contactNumbersList);
        hideLoadingScreen();
        showSnackBar(
            text: 'sendSosMessageSuccess'.tr,
            snackBarType: SnackBarType.success);
      } catch (err) {
        if (kDebugMode) {
          print(err.toString());
          showSnackBar(
              text: 'requiredFields'.tr, snackBarType: SnackBarType.error);
        }
      }
    } else if (contactsList.isEmpty) {
      showSnackBar(
          text: 'missingEmergencyContact'.tr, snackBarType: SnackBarType.error);
    } else {
      showSnackBar(text: 'requiredFields'.tr, snackBarType: SnackBarType.error);
    }
  }

  @override
  void onClose() {
    contactNameTextController.dispose();
    sosMessageController.dispose();
    super.onClose();
  }
}

class ContactItem {
  final String contactName;
  final String contactNumber;
  final String contactDocumentId;
  ContactItem({
    required this.contactName,
    required this.contactNumber,
    required this.contactDocumentId,
  });
  Map<String, dynamic> toJson() {
    return {
      'contactName': contactName,
      'contactNumber': contactNumber,
    };
  }
}
