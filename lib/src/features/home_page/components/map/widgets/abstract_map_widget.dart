import 'package:flutter/material.dart';

import 'map_widget_stub.dart'
    if (dart.library.html) 'web_map_widget.dart'
    if (dart.library.io) 'mobile_map_widget.dart';

abstract class MapWidget extends StatelessWidget {
  factory MapWidget() => getMapWidget();
}
