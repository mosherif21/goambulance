import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/features/requests/components/making_request/components/search_bar_map.dart';
import 'package:goambulance/src/features/requests/controllers/making_request_controller.dart';
import 'package:goambulance/src/general/common_widgets/regular_elevated_button.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart';

import '../../../../../constants/assets_strings.dart';
import '../../../../../general/common_widgets/back_button.dart';
import '../../../../../general/general_functions.dart';
import 'myLocation_button.dart';

class MakingRequestMap extends StatefulWidget {
  const MakingRequestMap({
    Key? key,
    required this.makingRequestController,
  }) : super(key: key);
  final MakingRequestController makingRequestController;

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

  @override
  Widget build(BuildContext context) {
    final screenHeight = getScreenHeight(context);
    return Stack(
      children: [
        GoogleMap(
          padding: const EdgeInsets.only(bottom: 70),
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
          onCameraMove: (cameraPosition) => widget
              .makingRequestController.currentCameraPosition = cameraPosition,
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
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                children: [
                  const CircleBackButton(padding: 0),
                  const SizedBox(width: 10),
                  Expanded(
                    child: MakingRequestMapSearch(
                      makingRequestController: widget.makingRequestController,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 10,
          left: 0,
          right: 0,
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: RegularElevatedButton(
              buttonText: 'requestHere'.tr,
              onPressed: () => widget.makingRequestController.onRequestPress(),
              enabled: true,
              color: Colors.black,
              fontSize: 20,
              height: 55,
            ),
          ),
        ),
        Positioned(
          bottom: 70,
          left: isLangEnglish() ? null : 0,
          right: isLangEnglish() ? 0 : null,
          child: MyLocationButton(
            onClick: () =>
                widget.makingRequestController.animateToCurrentLocation(),
            makingRequestController: widget.makingRequestController,
          ),
        ),
        Obx(
          () => Center(
            child: Container(
              margin: EdgeInsets.only(
                  bottom: widget.makingRequestController.mapPinMargin.value),
              child: Lottie.asset(
                kMapPin,
                repeat: false,
                height: screenHeight * 0.15,
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
    );
  }
}
