// ignore_for_file: invalid_use_of_protected_member

import 'package:auto_size_text/auto_size_text.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/features/requests/components/general/search_bar_map.dart';
import 'package:goambulance/src/features/requests/controllers/making_request_location_controller.dart';
import 'package:goambulance/src/general/common_widgets/regular_elevated_button.dart';
import 'package:google_map_marker_animation/helpers/extensions.dart';
import 'package:google_map_marker_animation/widgets/animarker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:line_icons/line_icons.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../../../../constants/assets_strings.dart';
import '../../../../../constants/enums.dart';
import '../../../../../general/app_init.dart';
import '../../../../../general/common_widgets/back_button.dart';
import '../../../../../general/common_widgets/no_frame_clickable_card.dart';
import '../../../../../general/general_functions.dart';
import '../../general/choose_hospitals_widget.dart';
import '../../general/my_location_button.dart';

class MakingRequestMap extends StatelessWidget {
  const MakingRequestMap({
    Key? key,
    required this.makingRequestController,
  }) : super(key: key);
  final MakingRequestLocationController makingRequestController;
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
      margin: const EdgeInsets.all(20),
      child: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            Obx(
              () => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: AutoSizeText(
                  makingRequestController.requestStatus.value ==
                          RequestStatus.pending
                      ? 'pendingRequest'.tr
                      : makingRequestController.requestStatus.value ==
                              RequestStatus.accepted
                          ? 'acceptedRequest'.tr
                          : makingRequestController.requestStatus.value ==
                                      RequestStatus.assigned ||
                                  makingRequestController.requestStatus.value ==
                                      RequestStatus.ongoing
                              ? 'assignedRequest'.tr
                              : makingRequestController
                                      .searchedHospitals.isEmpty
                                  ? 'searchingForHospitals'.tr
                                  : 'chooseRequestHospital'.tr,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                  maxLines: 1,
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Divider(thickness: 0.5, height: 1),
            Expanded(
              child: makingRequestController.requestStatus.value ==
                          RequestStatus.non ||
                      makingRequestController.requestStatus.value ==
                          RequestStatus.completed
                  ? ChooseHospitalsList(
                      controller: makingRequestController,
                    )
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          NoFrameClickableCard(
                            onPressed: () => makingRequestController
                                .viewHospitalInformation(),
                            title: 'viewHospitalInformation'.tr,
                            subTitle: '',
                            leadingIcon: LineIcons.hospital,
                            leadingIconColor: Colors.black,
                            leadingIconSize: 40,
                            trailingIcon: Icons.arrow_forward_ios_outlined,
                            trailingIconColor: Colors.grey,
                            padding: EdgeInsets.all(isLangEnglish() ? 16 : 13),
                          ),
                          NoFrameClickableCard(
                            onPressed: () => makingRequestController
                                .viewRequestInformation(),
                            title: 'viewRequestInformation'.tr,
                            subTitle: '',
                            leadingIcon: Icons.medical_information_outlined,
                            leadingIconColor: Colors.black,
                            leadingIconSize: 40,
                            trailingIcon: Icons.arrow_forward_ios_outlined,
                            trailingIconColor: Colors.grey,
                            padding: EdgeInsets.all(isLangEnglish() ? 16 : 13),
                          ),
                          Obx(
                            () => makingRequestController.requestStatus.value ==
                                        RequestStatus.assigned ||
                                    makingRequestController
                                            .requestStatus.value ==
                                        RequestStatus.ongoing
                                ? NoFrameClickableCard(
                                    onPressed: () => makingRequestController
                                        .viewAmbulanceInformation(),
                                    title: 'viewAmbulanceInformation'.tr,
                                    subTitle: '',
                                    leadingIcon: Icons.account_box,
                                    leadingIconColor: Colors.black,
                                    leadingIconSize: 40,
                                    trailingIcon:
                                        Icons.arrow_forward_ios_outlined,
                                    trailingIconColor: Colors.grey,
                                    padding: EdgeInsets.all(
                                        isLangEnglish() ? 16 : 13),
                                  )
                                : const SizedBox.shrink(),
                          ),
                        ],
                      ),
                    ),
            ),
            const Divider(thickness: 1, height: 2),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Obx(
                () => RegularElevatedButton(
                  buttonText: makingRequestController.requestStatus.value ==
                          RequestStatus.non
                      ? 'confirmRequest'.tr
                      : 'cancelRequest'.tr,
                  onPressed: makingRequestController.requestStatus.value ==
                          RequestStatus.non
                      ? makingRequestController.confirmRequest
                      : makingRequestController.cancelRequest,
                  enabled:
                      makingRequestController.selectedHospital.value != null
                          ? true
                          : false,
                  color: Colors.black,
                  fontSize: 22,
                  height: 50,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = getScreenHeight(context);
    return WillPopScope(
      onWillPop: makingRequestController.onWillPop,
      child: Scaffold(
        body: SlidingUpPanel(
          renderPanelSheet: false,
          controller: makingRequestController.hospitalsPanelController,
          panel: floatingPanel(),
          minHeight: 0,
          maxHeight: screenHeight * 0.45,
          isDraggable: false,
          body: Stack(
            children: [
              Obx(
                () => Animarker(
                  duration: makingRequestController.userRotation.value
                      ? const Duration(milliseconds: 2500)
                      : const Duration(milliseconds: 0),
                  useRotation: makingRequestController.userRotation.value,
                  mapId: makingRequestController.mapControllerCompleter.future
                      .then<int>((value) => value.mapId),
                  markers: makingRequestController.mapMarkers.value.set,
                  shouldAnimateCamera: false,
                  child: GoogleMap(
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
                                makingRequestController.choosingHospital.value
                                    ? screenHeight * 0.43
                                    : 70,
                            left: 10,
                            right: 10,
                            top: screenHeight * 0.16,
                          ),
                    initialCameraPosition:
                        makingRequestController.getInitialCameraPosition(),
                    polylines: makingRequestController.mapPolyLines.value,
                    onMapCreated: (GoogleMapController controller) =>
                        makingRequestController.mapControllerCompleter
                            .complete(controller),
                    onCameraMove: makingRequestController.onCameraMove,
                    onCameraIdle: makingRequestController.onCameraIdle,
                  ),
                ),
              ),
              CustomInfoWindow(
                controller:
                    makingRequestController.requestLocationWindowController,
                height: isLangEnglish() ? 50 : 56,
                width: 150,
                offset: 50,
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
                          onPress: makingRequestController.onBackPressed,
                        ),
                        const SizedBox(width: 10),
                        Obx(
                          () => makingRequestController.choosingHospital.value
                              ? const SizedBox.shrink()
                              : Expanded(
                                  child: MakingRequestMapSearch(
                                    locationController: makingRequestController,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Obx(
                () => !makingRequestController.choosingHospital.value
                    ? Positioned(
                        left: 0,
                        right: 0,
                        bottom: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: RegularElevatedButton(
                            buttonText: 'requestHere'.tr,
                            onPressed: () =>
                                makingRequestController.onRequestPress(),
                            enabled: true,
                            color: Colors.black,
                            fontSize: 22,
                            height: 60,
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
              Obx(
                () => Positioned(
                  bottom: makingRequestController.choosingHospital.value
                      ? isLangEnglish()
                          ? screenHeight * 0.43
                          : screenHeight * 0.452
                      : isLangEnglish()
                          ? 70
                          : 95,
                  left: isLangEnglish() ? null : 0,
                  right: isLangEnglish() ? 0 : null,
                  child: MyLocationButton(
                    onLocationButtonPress: () =>
                        makingRequestController.onLocationButtonPress(),
                  ),
                ),
              ),
              Obx(
                () => Center(
                  child: Container(
                    margin: EdgeInsets.only(
                      left: makingRequestController.cameraMoved.value ? 10 : 0,
                      right: makingRequestController.cameraMoved.value ? 10 : 0,
                      bottom:
                          makingRequestController.cameraMoved.value ? 16 : 73,
                    ),
                    height: makingRequestController.choosingHospital.value
                        ? 0
                        : screenHeight * 0.1,
                    child: Image.asset(kLocationMarkerImg),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
