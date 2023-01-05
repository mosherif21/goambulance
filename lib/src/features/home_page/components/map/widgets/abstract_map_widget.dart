import 'package:flutter/material.dart';

import 'map_widget_stub.dart'
    if (dart.library.html) 'package:client_ojp4danube/map/map_web_widget.dart'
    if (dart.library.io) 'abstract_map_widget.dart';

abstract class MapWidget extends StatelessWidget {
  factory MapWidget() => getMapWidget();
}
