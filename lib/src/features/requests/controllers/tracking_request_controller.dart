import 'package:get/get.dart';

import '../components/requests_history/models.dart';

class TrackingRequestController extends GetxController {
  static TrackingRequestController get instance => Get.find();
  late RequestHistoryModel initialRequestModel;
  TrackingRequestController({required this.initialRequestModel});
  @override
  void onReady() async {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
