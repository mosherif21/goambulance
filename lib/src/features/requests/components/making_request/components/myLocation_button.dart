import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:goambulance/src/features/requests/controllers/making_request_location_controller.dart';

import '../../../../../constants/assets_strings.dart';

class MyLocationButton extends StatelessWidget {
  const MyLocationButton(
      {Key? key, required this.onClick, required this.makingRequestController})
      : super(key: key);
  final Function onClick;
  final MakingRequestLocationController makingRequestController;
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AnimatedOpacity(
        opacity: makingRequestController.locationAvailable.value ? 1 : 0,
        duration: const Duration(milliseconds: 400),
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
                  height: 30,
                ),
              ),
              onTap: () => onClick(),
            ),
          ),
        ),
      ),
    );
  }
}
