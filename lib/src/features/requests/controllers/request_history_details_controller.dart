import 'package:get/get.dart';
import 'package:goambulance/src/features/requests/components/requests_history/models.dart';

class RequestsHistoryDetailsController extends GetxController {
  static RequestsHistoryDetailsController get instance => Get.find();
  late final RequestHistoryModel requestModel;
  RequestsHistoryDetailsController({required this.requestModel});
  final requestLoaded = false.obs;
  @override
  void onReady() async {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
