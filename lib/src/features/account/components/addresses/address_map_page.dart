import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../constants/assets_strings.dart';
import '../../../../general/app_init.dart';
import '../../../../general/common_widgets/back_button.dart';
import '../../../../general/common_widgets/regular_elevated_button.dart';
import '../../../../general/general_functions.dart';
import '../../../requests/components/making_request/components/my_location_button.dart';
import '../../../requests/components/making_request/components/search_bar_map.dart';
import '../../controllers/address_location_controller.dart';

class AddressMapPage extends StatelessWidget {
  const AddressMapPage({
    super.key,
    required this.addressLocationController,
  });
  final AddressesLocationController addressLocationController;
  @override
  Widget build(BuildContext context) {
    final screenHeight = getScreenHeight(context);
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            compassEnabled: false,
            rotateGesturesEnabled: false,
            tiltGesturesEnabled: false,
            mapToolbarEnabled: false,
            myLocationEnabled: true,
            zoomControlsEnabled: false,
            myLocationButtonEnabled: false,
            padding: AppInit.isWeb
                ? EdgeInsets.zero
                : EdgeInsets.only(
                    bottom: 70,
                    left: 10,
                    right: 10,
                    top: screenHeight * 0.16,
                  ),
            initialCameraPosition:
                addressLocationController.getInitialCameraPosition(),
            polylines: const {},
            markers: const {},
            onMapCreated: (GoogleMapController controller) =>
                addressLocationController.mapControllerCompleter
                    .complete(controller),
            onCameraMove: addressLocationController.onCameraMove,
            onCameraIdle: addressLocationController.onCameraIdle,
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  children: [
                    CircleBackButton(
                      padding: 0,
                      onPress: () => Get.back(),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: MakingRequestMapSearch(
                        locationController: addressLocationController,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: RegularElevatedButton(
                buttonText: 'confirmLocation'.tr,
                onPressed: () => addressLocationController.onLocationPress(),
                enabled: true,
                color: Colors.black,
                fontSize: 22,
                height: 60,
              ),
            ),
          ),
          Positioned(
            bottom: 70,
            left: isLangEnglish() ? null : 0,
            right: isLangEnglish() ? 0 : null,
            child: MyLocationButton(
              controller: addressLocationController,
            ),
          ),
          Center(
            child: Container(
              margin: EdgeInsets.only(
                left: addressLocationController.cameraMoved.value ? 10 : 0,
                right: addressLocationController.cameraMoved.value ? 10 : 0,
                bottom: addressLocationController.cameraMoved.value ? 16 : 74,
              ),
              height: screenHeight * 0.1,
              child: Image.asset(kLocationMarkerImg),
            ),
          ),
        ],
      ),
    );
  }
}
