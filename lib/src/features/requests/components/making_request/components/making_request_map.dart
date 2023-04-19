import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/features/requests/controllers/making_request_controller.dart';
import 'package:goambulance/src/general/common_widgets/regular_elevated_button.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart';

import '../../../../../constants/assets_strings.dart';
import '../../../../../general/common_widgets/back_button.dart';
import '../../../../../general/general_functions.dart';

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
          padding: const EdgeInsets.only(bottom: 70, left: 5),
          compassEnabled: false,
          rotateGesturesEnabled: false,
          tiltGesturesEnabled: false,
          mapToolbarEnabled: false,
          myLocationEnabled: true,
          zoomControlsEnabled: false,
          myLocationButtonEnabled: false,
          initialCameraPosition: CameraPosition(
            target: widget.makingRequestController.locationAvailable.value
                ? widget.makingRequestController.currentLocationGetter()
                : widget.makingRequestController.searchedLocation,
            zoom: 14.5,
          ),
          polylines: widget.makingRequestController.mapPolyLines,
          markers: widget.makingRequestController.mapMarkers,
          onMapCreated: (GoogleMapController controller) => widget
              .makingRequestController.mapControllerCompleter
              .complete(controller),
          onCameraMove: (cameraPosition) {},
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
          },
        ),
        Positioned(
          top: 0,
          left: isLangEnglish() ? 0 : null,
          right: isLangEnglish() ? null : 0,
          child: SafeArea(
            child: Row(
              children: const [
                CircleBackButton(padding: 15),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 20,
          left: 0,
          right: 0,
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Column(
              children: [
                RegularElevatedButton(
                  buttonText: 'requestHere'.tr,
                  onPressed: () {},
                  enabled: true,
                  color: Colors.black,
                  fontSize: 20,
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 70,
          left: isLangEnglish() ? null : 0,
          right: isLangEnglish() ? 0 : null,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Material(
                elevation: 5,
                shape: const CircleBorder(),
                color: Colors.white,
                child: InkWell(
                  customBorder: const CircleBorder(),
                  splashFactory: InkSparkle.splashFactory,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: SvgPicture.asset(
                      kMyLocation,
                    ),
                  ),
                  onTap: () {},
                ),
              ),
            ),
          ),
        ),
        Center(
          child: Container(
            margin: const EdgeInsets.only(bottom: 85),
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
      ],
    );
  }
}
