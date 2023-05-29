// ignore_for_file: invalid_use_of_protected_member

import 'package:auto_size_text/auto_size_text.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/features/requests/components/making_request/components/pending_request.dart';
import 'package:goambulance/src/features/requests/components/making_request/components/search_bar_map.dart';
import 'package:goambulance/src/features/requests/controllers/making_request_location_controller.dart';
import 'package:goambulance/src/general/common_widgets/regular_elevated_button.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../../../../constants/assets_strings.dart';
import '../../../../../constants/enums.dart';
import '../../../../../general/app_init.dart';
import '../../../../../general/common_widgets/back_button.dart';
import '../../../../../general/general_functions.dart';
import 'assigning_request.dart';
import 'choose_hospitals_widget.dart';
import 'my_location_button.dart';

class MakingRequestMap extends StatefulWidget {
  const MakingRequestMap({
    Key? key,
    required this.controller,
  }) : super(key: key);
  final MakingRequestLocationController controller;

  @override
  State<MakingRequestMap> createState() => _MakingRequestMapState();
}

class _MakingRequestMapState extends State<MakingRequestMap>
    with TickerProviderStateMixin {
  late AnimationController _pinAnimController;

  @override
  void initState() {
    super.initState();
    _pinAnimController = AnimationController(vsync: this);
    _pinAnimController.addListener(() {
      if (_pinAnimController.value > 0.6) {
        _pinAnimController.stop();
      }
    });
  }

  @override
  void dispose() {
    _pinAnimController.dispose();
    super.dispose();
  }

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
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: AutoSizeText(
                  widget.controller.requestStatus.value == RequestStatus.pending
                      ? 'pendingRequest'.tr
                      : widget.controller.requestStatus.value ==
                              RequestStatus.accepted
                          ? 'acceptedRequest'.tr
                          : widget.controller.requestStatus.value ==
                                  RequestStatus.assigned
                              ? 'assignedRequest'.tr
                              : widget.controller.searchedHospitals.isEmpty
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
              child: widget.controller.requestStatus.value == RequestStatus.non
                  ? ChooseHospitalsList(
                      controller: widget.controller,
                    )
                  : widget.controller.requestStatus.value ==
                          RequestStatus.pending
                      ? const PendingRequest()
                      : widget.controller.requestStatus.value ==
                              RequestStatus.accepted
                          ? const AcceptingRequest()
                          : const SizedBox.shrink(),
            ),
            const Divider(thickness: 1, height: 2),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Obx(
                () => RegularElevatedButton(
                  buttonText:
                      widget.controller.requestStatus.value == RequestStatus.non
                          ? 'confirmRequest'.tr
                          : 'cancelRequest'.tr,
                  onPressed:
                      widget.controller.requestStatus.value == RequestStatus.non
                          ? widget.controller.confirmRequest
                          : widget.controller.cancelRequest,
                  enabled: widget.controller.selectedHospital.value != null
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
    return Scaffold(
      body: WillPopScope(
        onWillPop: widget.controller.onWillPop,
        child: SlidingUpPanel(
          renderPanelSheet: false,
          controller: widget.controller.hospitalsPanelController,
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
                          bottom: widget.controller.choosingHospital.value
                              ? screenHeight * 0.48
                              : 70,
                          left: isLangEnglish() ? 10 : 40,
                          right: isLangEnglish() ? 40 : 10,
                          top: screenHeight * 0.16,
                        ),
                  initialCameraPosition:
                      widget.controller.getInitialCameraPosition(),
                  polylines: widget.controller.mapPolyLines.value,
                  markers: widget.controller.mapMarkers.value,
                  onMapCreated: (GoogleMapController controller) => widget
                      .controller.mapControllerCompleter
                      .complete(controller),
                  onCameraMove: widget.controller.onCameraMove,
                  onCameraMoveStarted: () {
                    if (!widget.controller.choosingHospital.value) {
                      setState(() {
                        _pinAnimController.stop();
                        _pinAnimController.reset();
                      });
                    }
                  },
                  onCameraIdle: () {
                    if (!widget.controller.choosingHospital.value) {
                      setState(() {
                        _pinAnimController.forward();
                      });
                      widget.controller.onCameraIdle();
                    }
                  },
                  onTap: widget.controller.onMapTap,
                ),
              ),
              CustomInfoWindow(
                controller: widget.controller.requestLocationWindowController,
                height: isLangEnglish() ? 58 : 75,
                width: 150,
                offset: 50,
              ),
              CustomInfoWindow(
                controller: widget.controller.hospitalWindowController,
                height: isLangEnglish() ? 58 : 75,
                width: 150,
                offset: 50,
              ),
              CustomInfoWindow(
                controller: widget.controller.ambulanceWindowController,
                height: isLangEnglish() ? 58 : 75,
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
                          onPress: widget.controller.onBackPressed,
                        ),
                        const SizedBox(width: 10),
                        Obx(
                          () => widget.controller.choosingHospital.value
                              ? const SizedBox.shrink()
                              : Expanded(
                                  child: MakingRequestMapSearch(
                                    makingRequestController: widget.controller,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Obx(
                () => !widget.controller.choosingHospital.value
                    ? Positioned(
                        left: 0,
                        right: 0,
                        bottom: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: RegularElevatedButton(
                            buttonText: 'requestHere'.tr,
                            onPressed: () => widget.controller.onRequestPress(),
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
                  bottom: widget.controller.choosingHospital.value
                      ? screenHeight * 0.48
                      : 70,
                  left: isLangEnglish() ? null : 0,
                  right: isLangEnglish() ? 0 : null,
                  child: MyLocationButton(
                    controller: widget.controller,
                  ),
                ),
              ),
              Obx(
                () => Center(
                  child: Container(
                    margin: EdgeInsets.only(
                      left: widget.controller.cameraMoved.value
                          ? isLangEnglish()
                              ? 10
                              : 40
                          : 0,
                      right: widget.controller.cameraMoved.value
                          ? isLangEnglish()
                              ? 40
                              : 10
                          : 0,
                      bottom: widget.controller.cameraMoved.value ? 18 : 80,
                    ),
                    height: widget.controller.choosingHospital.value
                        ? 0
                        : screenHeight * 0.15,
                    child: Lottie.asset(
                      kMapPin,
                      repeat: false,
                      controller: _pinAnimController,
                      onLoaded: (composition) {
                        _pinAnimController.duration = composition.duration;
                      },
                      frameRate: FrameRate.max,
                    ),
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
