// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
// ignore: depend_on_referenced_packages
import 'package:google_maps/google_maps.dart';

import 'abstract_map_widget.dart';

Widget getMap() {
  String htmlId = "7";

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
    return getMap();
  }
}

MapWidget getMapWidget() {
  if (kDebugMode) {
    print("Intra in get map web ");
  }
  return const WebMap();
}
