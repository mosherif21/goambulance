import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/features/home_screen/controllers/home_screen_controller.dart';
import 'package:goambulance/src/general/general_functions.dart';
import 'package:rolling_switch/rolling_switch.dart';

import '../../../constants/enums.dart';

class SosSettingsController extends GetxController {
  static SosSettingsController get instance => Get.find();
  final shakePrimaryKey = GlobalKey<RollingSwitchState>();
  final voicePrimaryKey = GlobalKey<RollingSwitchState>();
  final smsPrimaryKey = GlobalKey<RollingSwitchState>();
  late final HomeScreenController homeScreenController;
  @override
  void onInit() async {
    homeScreenController = HomeScreenController.instance;
    super.onInit();
  }

  @override
  void onReady() async {
    if (homeScreenController.shakeForSosEnabled) {
      shakePrimaryKey.currentState!.action();
    }
    if (homeScreenController.voiceForSosEnabled) {
      voicePrimaryKey.currentState!.action();
    }
    if (homeScreenController.smsForSosEnabled) {
      smsPrimaryKey.currentState!.action();
    }
  }

  void setShakeToSos(bool state) async {
    showLoadingScreen();
    final functionStatus = state
        ? await homeScreenController.enableShakeToSos()
        : await homeScreenController.disableShakeToSos();
    hideLoadingScreen();
    if (functionStatus != FunctionStatus.success) {
      shakePrimaryKey.currentState!.action();
      showSnackBar(
          text: 'failedToChangeSetting'.tr, snackBarType: SnackBarType.error);
    }
  }

  void setVoiceToSos(bool state) async {
    showLoadingScreen();
    final functionStatus = await homeScreenController.setVoiceToSos(set: state);
    hideLoadingScreen();
    if (functionStatus != FunctionStatus.success) {
      voicePrimaryKey.currentState!.action();
      showSnackBar(
          text: 'failedToChangeSetting'.tr, snackBarType: SnackBarType.error);
    }
  }

  void setSMSToSos(bool state) async {
    showLoadingScreen();
    final functionStatus = await homeScreenController.setSMSToSos(set: state);
    hideLoadingScreen();
    if (functionStatus != FunctionStatus.success) {
      smsPrimaryKey.currentState!.action();
      showSnackBar(
          text: 'failedToChangeSetting'.tr, snackBarType: SnackBarType.error);
    }
  }
}
