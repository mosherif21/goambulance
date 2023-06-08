// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../../../general/common_widgets/back_button.dart';
//
// class PaymentScreen extends StatelessWidget {
//   const PaymentScreen({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         leading: const RegularBackButton(padding: 0),
//         title: AutoSizeText(
//           'payment'.tr,
//           maxLines: 1,
//         ),
//         titleTextStyle: const TextStyle(
//             fontSize: 25, fontWeight: FontWeight.w600, color: Colors.black),
//         elevation: 0,
//         backgroundColor: Colors.white,
//       ),
//       backgroundColor: Colors.white,
//       body: const SafeArea(
//         child: Padding(
//           padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
//           child: StretchingOverscrollIndicator(
//             axisDirection: AxisDirection.down,
//             child: SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SizedBox(height: 20),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
////////////////////////////////////////////////////
import 'package:flutter/material.dart';
import 'package:flutter_mapbox_navigation/flutter_mapbox_navigation.dart';

import '../../../general/general_functions.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  Future<void> _onEmbeddedRouteEvent(e) async {
    // _distanceRemaining = await MapBoxNavigation.instance.getDistanceRemaining();
    // _durationRemaining = await MapBoxNavigation.instance.getDurationRemaining();

    switch (e.eventType) {
      case MapBoxEvent.progress_change:
        var progressEvent = e.data as RouteProgressEvent;
        if (progressEvent.currentStepInstruction != null) {
          // _instruction = progressEvent.currentStepInstruction;
        }
        break;
      case MapBoxEvent.route_building:
      case MapBoxEvent.route_built:
        //   setState(() {
        //     _routeBuilt = true;
        //   });
        //   break;
        // case MapBoxEvent.route_build_failed:
        //   setState(() {
        //     _routeBuilt = false;
        //   });
        //   break;
        // case MapBoxEvent.navigation_running:
        //   setState(() {
        //     _isNavigating = true;
        //   });
        break;
      case MapBoxEvent.on_arrival:
        // if (!_isMultipleStop) {
        //   await Future.delayed(const Duration(seconds: 3));
        //   await _controller?.finishNavigation();
        // } else {}
        break;
      case MapBoxEvent.navigation_finished:
      case MapBoxEvent.navigation_cancelled:
        // setState(() {
        //   _routeBuilt = false;
        //   _isNavigating = false;
        // });
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    MapBoxNavigation.instance.registerRouteEventListener(_onEmbeddedRouteEvent);
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: const Text("Start Navigation test"),
          onPressed: () async {
            final hospital = WayPoint(
              name: isLangEnglish() ? "Hospital" : "المستشفى",
              latitude: 31.21573006389394,
              longitude: 29.934194294709147,
              isSilent: false,
            );

            final patient = WayPoint(
              name: isLangEnglish() ? "Patient" : "المريض",
              latitude: 31.2333236,
              longitude: 29.9540145,
              isSilent: false,
            );
            var wayPoints = <WayPoint>[];
            wayPoints.add(patient);
            wayPoints.add(hospital);
            await MapBoxNavigation.instance.startNavigation(
              wayPoints: wayPoints,
              options: MapBoxOptions(
                initialLatitude: 31.2333236,
                initialLongitude: 29.9540145,
                zoom: 13.0,
                tilt: 0.0,
                bearing: 0.0,
                enableRefresh: false,
                alternatives: false,
                voiceInstructionsEnabled: true,
                bannerInstructionsEnabled: true,
                allowsUTurnAtWayPoints: true,
                mode: MapBoxNavigationMode.drivingWithTraffic,
                // mapStyleUrlDay: "https://url_to_day_style",
                // mapStyleUrlNight: "https://url_to_night_style",
                units: VoiceUnits.imperial,
                simulateRoute: false,
                language: "en",
                longPressDestinationEnabled: true,
                isOptimized: true,
                showReportFeedbackButton: false,
                // showEndOfRouteFeedback: ,
              ),
            );
          },
        ),
      ),
    );
  }
}
