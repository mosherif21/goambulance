// ignore_for_file: invalid_use_of_protected_member

import 'package:auto_size_text/auto_size_text.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/features/requests/controllers/tracking_request_controller.dart';
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
import '../../../../../general/common_widgets/regular_elevated_button.dart';
import '../../../../../general/general_functions.dart';
import '../../general/choose_hospitals_widget.dart';
import '../../general/my_location_button.dart';
import '../../general/search_bar_map.dart';
import '../../models.dart';

class TrackingRequestPage extends StatelessWidget {
  const TrackingRequestPage({Key? key, required this.requestModel})
      : super(key: key);
  final RequestHistoryDataModel requestModel;

  Widget floatingPanel(
      {required TrackingRequestController trackingController}) {
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
                  trackingController.requestStatus.value ==
                          RequestStatus.pending
                      ? 'pendingRequest'.tr
                      : trackingController.requestStatus.value ==
                              RequestStatus.accepted
                          ? 'acceptedRequest'.tr
                          : trackingController.requestStatus.value ==
                                  RequestStatus.assigned
                              ? 'assignedRequest'.tr
                              : trackingController.requestStatus.value ==
                                      RequestStatus.ongoing
                                  ? 'ambulanceRequestOngoing'.tr
                                  : trackingController.searchedHospitals.isEmpty
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
              child: trackingController.requestStatus.value ==
                          RequestStatus.non ||
                      trackingController.requestStatus.value ==
                          RequestStatus.completed
                  ? ChooseHospitalsList(
                      controller: trackingController,
                    )
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          NoFrameClickableCard(
                            onPressed: () =>
                                trackingController.viewHospitalInformation(),
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
                            onPressed: () =>
                                trackingController.viewRequestInformation(),
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
                            () => trackingController.requestStatus.value ==
                                        RequestStatus.assigned ||
                                    trackingController.requestStatus.value ==
                                        RequestStatus.ongoing
                                ? NoFrameClickableCard(
                                    onPressed: () => trackingController
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
                  buttonText: trackingController.requestStatus.value ==
                          RequestStatus.non
                      ? 'confirmRequest'.tr
                      : 'cancelRequest'.tr,
                  onPressed: trackingController.requestStatus.value ==
                          RequestStatus.non
                      ? trackingController.confirmRequestPress
                      : trackingController.cancelRequest,
                  enabled: trackingController.selectedHospital.value != null &&
                          trackingController.requestStatus.value !=
                              RequestStatus.ongoing
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
    final trackingController =
        Get.put(TrackingRequestController(initialRequestModel: requestModel));

    final screenHeight = getScreenHeight(context);
    return Scaffold(
      body: WillPopScope(
        onWillPop: trackingController.onWillPop,
        child: SlidingUpPanel(
          renderPanelSheet: false,
          controller: trackingController.hospitalsPanelController,
          panel: floatingPanel(trackingController: trackingController),
          minHeight: 0,
          maxHeight: screenHeight * 0.45,
          isDraggable: false,
          body: Stack(
            children: [
              Obx(
                () => Animarker(
                  duration: const Duration(milliseconds: 2500),
                  useRotation: true,
                  mapId: trackingController.mapControllerCompleter.future
                      .then<int>((value) => value.mapId),
                  markers: trackingController.mapMarkersAnimated.value.set,
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
                            bottom: trackingController.choosingHospital.value
                                ? screenHeight * 0.43
                                : 70,
                            left: 10,
                            right: 10,
                            top: screenHeight * 0.16,
                          ),
                    initialCameraPosition:
                        trackingController.getInitialCameraPosition(),
                    polylines: trackingController.mapPolyLines.value,
                    markers: trackingController.mapMarkers.value,
                    onMapCreated: (GoogleMapController controller) =>
                        trackingController.mapControllerCompleter
                            .complete(controller),
                    onCameraMove: trackingController.onCameraMove,
                    onCameraIdle: trackingController.onCameraIdle,
                  ),
                ),
              ),
              CustomInfoWindow(
                controller: trackingController.requestLocationWindowController,
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
                          onPress: trackingController.onBackPressed,
                        ),
                        const SizedBox(width: 10),
                        Obx(
                          () => trackingController.choosingHospital.value
                              ? const SizedBox.shrink()
                              : Expanded(
                                  child: MakingRequestMapSearch(
                                    locationController: trackingController,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Obx(
                () => !trackingController.choosingHospital.value
                    ? Positioned(
                        left: 0,
                        right: 0,
                        bottom: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: RegularElevatedButton(
                            buttonText: 'requestHere'.tr,
                            onPressed: () =>
                                trackingController.onRequestPress(),
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
                  bottom: trackingController.choosingHospital.value
                      ? isLangEnglish()
                          ? screenHeight * 0.43
                          : screenHeight * 0.452
                      : isLangEnglish()
                          ? 70
                          : 90,
                  left: isLangEnglish() ? null : 0,
                  right: isLangEnglish() ? 0 : null,
                  child: MyLocationButton(
                    onLocationButtonPress: () =>
                        trackingController.onLocationButtonPress(),
                  ),
                ),
              ),
              Obx(
                () => Center(
                  child: Container(
                    margin: EdgeInsets.only(
                      left: trackingController.cameraMoved.value ? 10 : 0,
                      right: trackingController.cameraMoved.value ? 10 : 0,
                      bottom: trackingController.cameraMoved.value ? 16 : 73,
                    ),
                    height: trackingController.choosingHospital.value
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
