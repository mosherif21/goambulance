import 'dart:async';

import 'package:get/get.dart';

import '../../../general/general_functions.dart';
import '../components/making_request/components/normal_request_location_page.dart';

class MakingRequestInformationController extends GetxController {
  static MakingRequestInformationController get instance => Get.find();

  @override
  void onReady() async {
    super.onReady();
  }

  Future<void> confirmRequestInformation() async {
    showLoadingScreen();
    hideLoadingScreen();
    Get.to(
      () => const NormalRequestLocationPage(),
      transition: getPageTransition(),
    );
  }

  @override
  void onClose() async {
    super.onClose();
  }
}
