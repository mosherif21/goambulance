import 'package:background_sms/background_sms.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/authentication/authentication_repository.dart';
import 'package:goambulance/firebase_files/firebase_patient_access.dart';
import 'package:goambulance/src/constants/enums.dart';
import 'package:intl_phone_field/phone_number.dart';

import '../../../general/app_init.dart';
import '../../../general/common_widgets/regular_bottom_sheet.dart';
import '../../../general/general_functions.dart';

class SosMessageController extends GetxController {
  static SosMessageController get instance => Get.find();

  final formKey = GlobalKey<FormState>();

  //vars
  final contactName = ''.obs;
  final phoneNumber = ''.obs;
  final highlightSosMessage = false.obs;
  final sosMessageDataLoaded = false.obs;
  String sosMessage = '';
  String savedSosMessage = '';
  final contactsList = <ContactItem>[].obs;
  late final FirebasePatientDataAccess firebasePatientDataAccess;
  late final AuthenticationRepository authRepo;
  final enableSaveButton = false.obs;

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
  void onReady() {
    super.onReady();
    loadSosMsgData();
    sosMessageController.addListener(() {
      if (sosMessageController.text.trim().isNotEmpty) {
        highlightSosMessage.value = false;
      }
      sosMessage = sosMessageController.text.trim();
      if (sosMessage.compareTo(savedSosMessage) != 0) {
        enableSaveButton.value = true;
      } else {
        enableSaveButton.value = false;
      }
    });
    contactNameTextController.addListener(() {
      contactName.value = contactNameTextController.text.trim();
    });
    handleSmsPermission();
  }

  void loadSosMsgData() async {
    contactsList.value = await firebasePatientDataAccess.getEmergencyContacts();
    savedSosMessage = authRepo.userInfo.sosMessage;
    sosMessageController.text = savedSosMessage;
    sosMessage = savedSosMessage;
    sosMessageDataLoaded.value = true;
  }

  void addContact() async {
    if (formKey.currentState!.validate()) {
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
  }

  onPhoneNumberChanged(PhoneNumber phoneValue) {
    final enteredPhone = phoneValue.completeNumber;
    if (enteredPhone.isPhoneNumber && enteredPhone.length == 13) {
      phoneNumber.value = enteredPhone;
    } else {
      phoneNumber.value = '';
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

  Future<void> saveSosMessage({required bool displaySnackBar}) async {
    if (savedSosMessage.compareTo(sosMessage) != 0) {
      final functionStatus = await firebasePatientDataAccess.saveSosMessage(
          sosMessage: sosMessage);
      authRepo.userInfo.sosMessage = sosMessage;
      savedSosMessage = sosMessage;
      enableSaveButton.value = false;
      if (functionStatus == FunctionStatus.success) {
        if (displaySnackBar) {
          showSnackBar(
              text: 'sosMessageSaved'.tr, snackBarType: SnackBarType.success);
        }
      } else if (functionStatus == FunctionStatus.failure) {
        if (displaySnackBar) {
          showSnackBar(
              text: 'savingSosMessageFailed'.tr,
              snackBarType: SnackBarType.error);
        }
      }
    }
  }

  void onSaveSosMessageClick() async {
    showLoadingScreen();
    await saveSosMessage(displaySnackBar: true);
    FocusManager.instance.primaryFocus?.unfocus();
    hideLoadingScreen();
  }

  void sendSosMessage() async {
    if (!AppInit.isWeb) {
      if (await handleSmsPermission()) {
        highlightSosMessage.value = sosMessage.isEmpty;
        if (!highlightSosMessage.value && contactsList.isNotEmpty) {
          showLoadingScreen();
          await saveSosMessage(displaySnackBar: false);
          try {
            for (var contact in contactsList) {
              SmsStatus result = await BackgroundSms.sendMessage(
                  phoneNumber: contact.contactNumber, message: sosMessage);
              if (kDebugMode) {
                if (result == SmsStatus.sent) {
                  print("SMS sent");
                } else {
                  print("SMS failed");
                }
              }
            }
            showSnackBar(
                text: 'sendSosMessageSuccess'.tr,
                snackBarType: SnackBarType.success);
          } catch (err) {
            if (kDebugMode) {
              print(err.toString());
              showSnackBar(
                  text: 'sendingSosMessageFailed'.tr,
                  snackBarType: SnackBarType.error);
            }
          }
          hideLoadingScreen();
        } else if (highlightSosMessage.value) {
          showSnackBar(
              text: 'requiredFields'.tr, snackBarType: SnackBarType.error);
        } else if (contactsList.isEmpty) {
          showSnackBar(
              text: 'missingEmergencyContact'.tr,
              snackBarType: SnackBarType.error);
        }
      }
    } else {
      showSnackBar(
          text: 'useMobileToThisFeature'.tr, snackBarType: SnackBarType.info);
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
