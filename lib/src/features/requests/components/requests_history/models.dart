import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../constants/enums.dart';

class StaticMarkerModel {
  final LatLng location;
  final String iconUrl;

  StaticMarkerModel({
    required this.location,
    required this.iconUrl,
  });
}

class RequestHistoryModel {
  final String requestId;
  final String hospitalName;
  final String? mapUrl;
  final String requestDateTime;
  final RequestStatus requestStatus;
  final LatLng location;
  RequestHistoryModel({
    required this.requestId,
    required this.hospitalName,
    required this.requestDateTime,
    required this.requestStatus,
    required this.location,
    this.mapUrl,
  });
}
