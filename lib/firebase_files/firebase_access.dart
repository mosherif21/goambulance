import 'package:get/get.dart';
import 'package:goambulance/src/features/home_page/components/map/map_controllers/maps_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FirebaseDataAccess extends GetxController {
  static FirebaseDataAccess get instance => Get.find();

  final LatLng _driverLocation =
      const LatLng(31.223958388803208, 29.93226379758089);
  @override
  void onInit() {
    super.onInit();
    driverLocationChanged();
  }

  void driverLocationChanged() {
    final mapsController = MapsController.instance;
    mapsController.getPolyPoints(
      _driverLocation,
    );
  }
}
