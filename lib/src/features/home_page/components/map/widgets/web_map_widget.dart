// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
// ignore: depend_on_referenced_packages
import 'package:google_maps/google_maps.dart';

import '../../../../../general/common_functions.dart';
import '../map_controllers/maps_controller.dart';
import 'abstract_map_widget.dart';

Widget getMap() {
  String htmlId = "id_map_web";

  // ignore: undefined_prefixed_name
  ui.platformViewRegistry.registerViewFactory(htmlId, (int viewId) {
    final myLatLng = LatLng(30.2669444, -97.7427778);

    final mapOptions = MapOptions()
      ..zoom = 8
      ..center = LatLng(30.2669444, -97.7427778);

    final elem = DivElement()
      ..id = htmlId
      ..style.width = "100%"
      ..style.height = "100%"
      ..style.border = 'none';

    final map = GMap(elem, mapOptions);

    Marker(MarkerOptions()
      ..position = myLatLng
      ..map = map
      ..title = 'Hello World!');

    return elem;
  });

  return HtmlElementView(viewType: htmlId);
}

class WebMap extends StatelessWidget implements MapWidget {
  const WebMap({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenHeight = getScreenHeight(context);
    final mapsController = MapsController.instance;
    return Obx(
      () => mapsController.servicePermissionEnabled.value
          ? SizedBox(
              height: screenHeight * 0.8,
              child: getMap(),
            )
          : SizedBox(
              height: screenHeight * 0.8,
              child: const Center(child: Text('location disabled'))),
    );
  }
}

MapWidget getMapWidget() {
  if (kDebugMode) {
    print("get map web ");
  }
  return const WebMap();
}
