// ignore_for_file: invalid_use_of_protected_member

import 'package:auto_size_text/auto_size_text.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../../../../general/app_init.dart';
import '../../../../../general/common_widgets/no_frame_clickable_card.dart';
import '../../../../../general/common_widgets/regular_elevated_button.dart';
import '../../../../../general/general_functions.dart';
import '../../../../requests/components/making_request/components/my_location_button.dart';
import '../../controllers/employee_home_screen_controller.dart';
import 'loading_request_option.dart';

class EmployeeMapScreen extends StatelessWidget {
  const EmployeeMapScreen(
      {super.key, required this.employeeHomeScreenController});
  final EmployeeHomeScreenController employeeHomeScreenController;
  Widget floatingPanel() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            color: Colors.grey.shade500,
          ),
        ],
      ),
      margin: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 105),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: AutoSizeText(
              'assignedRequestHeader'.tr,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
              maxLines: 1,
            ),
          ),
          const SizedBox(height: 8),
          const Divider(thickness: 0.5, height: 1),
          Expanded(
            child: Obx(
              () => employeeHomeScreenController.assignedRequestLoaded.value
                  ? SingleChildScrollView(
                      child: Column(
                        children: [
                          NoFrameClickableCard(
                            onPressed: () => employeeHomeScreenController
                                .onUserInformationPressed(),
                            title: 'userInformation'.tr,
                            subTitle: '',
                            leadingIcon: Icons.account_box,
                            leadingIconColor: Colors.black,
                            trailingIcon: Icons.arrow_forward_ios_outlined,
                            trailingIconColor: Colors.grey,
                            padding: EdgeInsets.symmetric(
                                vertical: isLangEnglish() ? 14 : 12,
                                horizontal: 12),
                          ),
                          NoFrameClickableCard(
                            onPressed: () => employeeHomeScreenController
                                .onMedicalInformationPressed(),
                            title: 'PatientMedicalInformation'.tr,
                            subTitle: '',
                            leadingIcon: Icons.medical_information_outlined,
                            leadingIconColor: Colors.black,
                            trailingIcon: Icons.arrow_forward_ios_outlined,
                            trailingIconColor: Colors.grey,
                            padding: EdgeInsets.symmetric(
                                vertical: isLangEnglish() ? 14 : 12,
                                horizontal: 12),
                          ),
                          NoFrameClickableCard(
                            onPressed: () => employeeHomeScreenController
                                .onStartNavigationPressed(),
                            title: 'startNavigation'.tr,
                            subTitle: '',
                            leadingIcon: Icons.navigation_outlined,
                            leadingIconColor: Colors.black,
                            trailingIcon: Icons.arrow_forward_ios_outlined,
                            trailingIconColor: Colors.grey,
                            padding: EdgeInsets.symmetric(
                                vertical: isLangEnglish() ? 14 : 12,
                                horizontal: 12),
                          ),
                        ],
                      ),
                    )
                  : const LoadingRequestInfo(),
            ),
          ),
          const Divider(thickness: 1, height: 2),
          Padding(
            padding:
                const EdgeInsets.only(left: 30, right: 30, bottom: 13, top: 10),
            child: Obx(
              () => RegularElevatedButton(
                buttonText: 'confirmPickup'.tr,
                onPressed: () {},
                enabled:
                    employeeHomeScreenController.assignedRequestLoaded.value
                        ? true
                        : false,
                color: Colors.black,
                fontSize: 22,
                height: 45,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = getScreenHeight(context);
    return SlidingUpPanel(
      renderPanelSheet: false,
      controller: employeeHomeScreenController.requestPanelController,
      panel: floatingPanel(),
      minHeight: 0,
      maxHeight: screenHeight * 0.5,
      isDraggable: false,
      body: Stack(
        children: [
          Obx(
            () => GoogleMap(
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
                      bottom:
                          employeeHomeScreenController.hasAssignedRequest.value
                              ? screenHeight * 0.48
                              : 80,
                      left: 10,
                      right: 10,
                      top: screenHeight * 0.16,
                    ),
              initialCameraPosition:
                  employeeHomeScreenController.getInitialCameraPosition(),
              polylines: employeeHomeScreenController.mapPolyLines.value,
              markers: employeeHomeScreenController.mapMarkers.value,
              onMapCreated: (GoogleMapController controller) =>
                  employeeHomeScreenController.mapControllerCompleter
                      .complete(controller),
              onCameraMove: employeeHomeScreenController.onCameraMove,
              onCameraIdle: employeeHomeScreenController.onCameraIdle,
              onTap: employeeHomeScreenController.onMapTap,
            ),
          ),
          CustomInfoWindow(
            controller:
                employeeHomeScreenController.requestLocationWindowController,
            height: isLangEnglish() ? 50 : 56,
            width: 150,
            offset: 50,
          ),
          // CustomInfoWindow(
          //   controller: employeeHomeScreenController.hospitalWindowController,
          //   height: isLangEnglish() ? 50 : 56,
          //   width: 150,
          //   offset: 50,
          // ),
          // CustomInfoWindow(
          //   controller: makingRequestController.ambulanceWindowController,
          //   height: isLangEnglish() ? 50 : 56,
          //   width: 150,
          //   offset: 50,
          // ),
          Obx(
            () => Positioned(
              bottom: employeeHomeScreenController.hasAssignedRequest.value
                  ? isLangEnglish()
                      ? screenHeight * 0.48
                      : screenHeight * 0.51
                  : isLangEnglish()
                      ? 80
                      : 105,
              left: isLangEnglish() ? null : 0,
              right: isLangEnglish() ? 0 : null,
              child: MyLocationButton(
                onLocationButtonPress: () =>
                    employeeHomeScreenController.onLocationButtonPress(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
