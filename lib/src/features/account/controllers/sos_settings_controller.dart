import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:rolling_switch/rolling_switch.dart';

class SosSettingsController extends GetxController {
  static SosSettingsController get instance => Get.find();
  final shakePrimaryKey = GlobalKey<RollingSwitchState>();
  final voicePrimaryKey = GlobalKey<RollingSwitchState>();
  final smsPrimaryKey = GlobalKey<RollingSwitchState>();
  bool shakeSOS = false;
  bool voiceSOS = false;
  bool smsSOS = false;
  @override
  void onInit() async {
    super.onInit();
  }

  @override
  void onReady() async {}
  @override
  void onClose() {
    super.onClose();
  }
}
