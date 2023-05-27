import 'package:cloud_firestore/cloud_firestore.dart';
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
  final String userId;
  final String hospitalId;
  final String hospitalName;
  final String backupNumber;
  final String patientCondition;
  final String? mapUrl;
  final String requestDateTime;
  final RequestStatus requestStatus;
  final bool isUser;
  final LatLng requestLocation;
  final LatLng hospitalLocation;
  final Timestamp timeStamp;

  RequestHistoryModel({
    required this.requestId,
    required this.userId,
    required this.backupNumber,
    required this.patientCondition,
    required this.isUser,
    required this.hospitalId,
    required this.timeStamp,
    required this.hospitalName,
    required this.requestDateTime,
    required this.requestStatus,
    required this.requestLocation,
    required this.hospitalLocation,
    this.mapUrl,
  });
}
