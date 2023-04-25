// ignore_for_file: invalid_use_of_protected_member

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/features/requests/components/making_request/components/search_bar_map.dart';
import 'package:goambulance/src/features/requests/controllers/making_request_location_controller.dart';
import 'package:goambulance/src/general/common_widgets/regular_elevated_button.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../../../../constants/assets_strings.dart';
import '../../../../../general/common_widgets/back_button.dart';
import '../../../../../general/general_functions.dart';
import 'choose_hospitals_widget.dart';
import 'myLocation_button.dart';

class MakingRequestMap extends StatefulWidget {
  const MakingRequestMap({
    Key? key,
    required this.makingRequestController,
  }) : super(key: key);
  final MakingRequestLocationController makingRequestController;

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
            blurRadius: 20,
            color: Colors.grey.shade400,
          ),
        ],
      ),
      margin: const EdgeInsets.all(20),
      // padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          AutoSizeText(
            'chooseRequestHospital'.tr,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 8),
          const Divider(height: 5),
          Expanded(
            child: ChooseHospitalsList(
              makingRequestLocationController: widget.makingRequestController,
            ),
          ),
          const Divider(thickness: 1, height: 2),
          Padding(
            padding: const EdgeInsets.all(18),
            child: RegularElevatedButton(
              buttonText: 'confirmRequest'.tr,
              onPressed: () {},
              enabled: true,
              color: Colors.black,
              fontSize: 22,
              height: 50,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = getScreenHeight(context);
    return Scaffold(
      body: WillPopScope(
        onWillPop: () {
          if (widget.makingRequestController.choosingHospital.value) {
            widget.makingRequestController.choosingRequestLocationChanges();
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: SlidingUpPanel(
          renderPanelSheet: false,
          controller: widget.makingRequestController.hospitalsPanelController,
          panel: floatingPanel(),
          minHeight: 0,
          maxHeight: screenHeight * 0.5,
          isDraggable: false,
          body: Stack(
            children: [
              Obx(
                () => GoogleMap(
                  padding: EdgeInsets.only(
                    bottom:
                        widget.makingRequestController.choosingHospital.value
                            ? screenHeight * 0.48
                            : 70,
                    left: isLangEnglish() ? 8 : 0,
                    right: isLangEnglish() ? 0 : 8,
                    top: 60,
                  ),
                  compassEnabled: false,
                  rotateGesturesEnabled: false,
                  tiltGesturesEnabled: false,
                  mapToolbarEnabled: false,
                  myLocationEnabled: true,
                  zoomControlsEnabled: false,
                  myLocationButtonEnabled: false,
                  initialCameraPosition:
                      widget.makingRequestController.getInitialCameraPosition(),
                  polylines: widget.makingRequestController.mapPolyLines.value,
                  markers: widget.makingRequestController.mapMarkers.value,
                  onMapCreated: (GoogleMapController controller) => widget
                      .makingRequestController.mapControllerCompleter
                      .complete(controller),
                  onCameraMove: widget.makingRequestController.onCameraMove,
                  onCameraMoveStarted: () {
                    if (!widget
                        .makingRequestController.choosingHospital.value) {
                      setState(() {
                        _pinAnimController.stop();
                        _pinAnimController.reset();
                      });
                    }
                  },
                  onCameraIdle: () {
                    if (!widget
                        .makingRequestController.choosingHospital.value) {
                      setState(() {
                        _pinAnimController.forward();
                      });
                      widget.makingRequestController.onCameraIdle();
                    }
                  },
                ),
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
                          onPress: () {
                            if (widget.makingRequestController.choosingHospital
                                .value) {
                              widget.makingRequestController
                                  .choosingRequestLocationChanges();
                            } else {
                              Get.back();
                            }
                          },
                        ),
                        const SizedBox(width: 10),
                        Obx(
                          () => widget.makingRequestController.choosingHospital
                                  .value
                              ? const SizedBox.shrink()
                              : Expanded(
                                  child: MakingRequestMapSearch(
                                    makingRequestController:
                                        widget.makingRequestController,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Obx(
                () => !widget.makingRequestController.choosingHospital.value
                    ? Positioned(
                        left: 0,
                        right: 0,
                        bottom: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: RegularElevatedButton(
                            buttonText: 'requestHere'.tr,
                            onPressed: () =>
                                widget.makingRequestController.onRequestPress(),
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
                  bottom: widget.makingRequestController.choosingHospital.value
                      ? screenHeight * 0.48
                      : 70,
                  left: isLangEnglish() ? null : 0,
                  right: isLangEnglish() ? 0 : null,
                  child: MyLocationButton(
                    onClick: () => widget.makingRequestController
                        .animateToCurrentLocation(),
                    makingRequestController: widget.makingRequestController,
                  ),
                ),
              ),
              Obx(
                () => Center(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    margin: EdgeInsets.only(
                        bottom:
                            widget.makingRequestController.mapPinMargin.value),
                    height:
                        widget.makingRequestController.choosingHospital.value
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
