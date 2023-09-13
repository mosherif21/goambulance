import 'package:get/get.dart';

import '../../../constants/no_localization_strings.dart';
import '../../../general/general_functions.dart';
import '../../../general/map_utils.dart';
import '../components/models.dart';

class RequestsHistoryDetailsController extends GetxController {
  static RequestsHistoryDetailsController get instance => Get.find();
  late final RequestHistoryDataModel requestModel;
  RequestsHistoryDetailsController({required this.requestModel});
  final mapUrl = ''.obs;
  @override
  void onReady() async {
    getStaticMapImgURL(
      marker1IconUrl: requestMarkerImageUrl,
      marker1LatLng: requestModel.requestLocation,
      marker1TitleIconUrl:
          isLangEnglish() ? requestEngImageUrl : requestArImageUrl,
      marker2IconUrl: hospitalMarkerImageUrl,
      marker2LatLng: requestModel.hospitalLocation,
      marker2TitleIconUrl:
          isLangEnglish() ? hospitalEngImageUrl : hospitalArImageUrl,
      sizeWidth: 350,
      sizeHeight: 200,
    ).then((mapImgUrl) => mapUrl.value = mapImgUrl);
    super.onReady();
  }

  // @override
  // void onClose() {
  //   super.onClose();
  // }
}
