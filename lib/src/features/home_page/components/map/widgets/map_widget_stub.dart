import 'abstract_map_widget.dart';

// Created because importing dart.html on a mobile app breaks the build
MapWidget getMapWidget() => throw UnsupportedError(
    'Cannot create a map without dart:html or google_maps_flutter');
