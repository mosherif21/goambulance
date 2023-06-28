// ignore_for_file: invalid_use_of_protected_member

import 'package:auto_size_text/auto_size_text.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:goambulance/src/general/common_widgets/no_frame_clickable_card.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../../../../general/app_init.dart';
import '../../../../../general/common_widgets/regular_elevated_button.dart';
import '../../../../../general/general_functions.dart';
import '../../../../requests/components/making_request/components/my_location_button.dart';
import '../../controllers/employee_home_screen_controller.dart';

class EmployeeMapScreen extends StatelessWidget {
  const EmployeeMapScreen({super.key});
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
      margin: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: AutoSizeText(
              'Assigned request',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
              maxLines: 1,
            ),
          ),
          const SizedBox(height: 8),
          const Divider(thickness: 0.5, height: 1),
          NoFrameClickableCard(
            onPressed: () {},
            title: 'User information',
            subTitle: '',
            leadingIcon: Icons.account_box,
            leadingIconColor: Colors.black,
            trailingIcon: Icons.arrow_forward_ios_outlined,
            trailingIconColor: Colors.grey,
          ),
          NoFrameClickableCard(
            onPressed: () {},
            title: 'Patient medical information',
            subTitle: '',
            leadingIcon: Icons.medical_information_outlined,
            leadingIconColor: Colors.black,
            trailingIcon: Icons.arrow_forward_ios_outlined,
            trailingIconColor: Colors.grey,
          ),
          NoFrameClickableCard(
            onPressed: () {},
            title: 'Start navigation',
            subTitle: '',
            leadingIcon: Icons.navigation_outlined,
            leadingIconColor: Colors.black,
            trailingIcon: Icons.arrow_forward_ios_outlined,
            trailingIconColor: Colors.grey,
          ),
          const Divider(thickness: 1, height: 2),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
            child: RegularElevatedButton(
              buttonText: 'Confirm pickup',
              onPressed: () {},
              enabled: true,
              color: Colors.black,
              fontSize: 22,
              height: 45,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = getScreenHeight(context);
    final employeeHomeScreenController = EmployeeHomeScreenController.instance;
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
                  ? screenHeight * 0.48
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
