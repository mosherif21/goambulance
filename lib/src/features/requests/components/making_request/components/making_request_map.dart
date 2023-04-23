import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/features/requests/components/making_request/components/search_bar_map.dart';
import 'package:goambulance/src/features/requests/controllers/making_request_location_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../../../../constants/assets_strings.dart';
import '../../../../../general/common_widgets/back_button.dart';
import '../../../../../general/general_functions.dart';
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

  Widget floatingCollapsed() {
    widget.makingRequestController.requestButtonFocusNode.requestFocus();
    return Focus(
      focusNode: widget.makingRequestController.requestButtonFocusNode,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0)),
        ),
        margin: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 0.0),
        child: Material(
          color: Colors.black,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0)),
          child: InkWell(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24.0),
                topRight: Radius.circular(24.0)),
            splashFactory: InkSparkle.splashFactory,
            onTap: () => widget.makingRequestController.onRequestPress(),
            child: Center(
              child: AutoSizeText(
                'requestHere'.tr,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 22),
                maxLines: 1,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget floatingPanel() {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(24.0)),
          boxShadow: [
            BoxShadow(
              blurRadius: 20.0,
              color: Colors.grey,
            ),
          ]),
      margin: const EdgeInsets.all(24.0),
      child: const Center(
        child: Text("This is the SlidingUpPanel when open"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = getScreenHeight(context);
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
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
          collapsed: floatingCollapsed(),
          minHeight: screenHeight * 0.1,
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
                            : screenHeight * 0.08,
                    left: isLangEnglish() ? 8 : 0,
                    right: isLangEnglish() ? 0 : 8,
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
                  polylines: widget.makingRequestController.mapPolyLines,
                  markers: widget.makingRequestController.mapMarkers,
                  onMapCreated: (GoogleMapController controller) => widget
                      .makingRequestController.mapControllerCompleter
                      .complete(controller),
                  onCameraMove: (cameraPosition) {
                    widget.makingRequestController.currentCameraLatLng =
                        cameraPosition.target;
                    widget.makingRequestController.cameraMoved = true;
                  },
                  onCameraMoveStarted: () {
                    setState(() {
                      _pinAnimController.stop();
                      _pinAnimController.reset();
                    });
                  },
                  onCameraIdle: () {
                    setState(() {
                      _pinAnimController.forward();
                    });
                    widget.makingRequestController.onCameraIdle();
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
                          onPress: () async {
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
                () => Positioned(
                  bottom: widget.makingRequestController.choosingHospital.value
                      ? screenHeight * 0.48
                      : screenHeight * 0.08,
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
                  child: Container(
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
