import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../constants/enums.dart';
import '../../../account/components/models.dart';

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
  RxString mapUrl = ''.obs;
  final String requestDateTime;
  RequestStatus requestStatus;
  final bool isUser;
  final LatLng requestLocation;
  final LatLng hospitalLocation;
  final Timestamp timeStamp;
  String? cancelReason;
  String? ambulanceCarID;
  String? ambulanceDriverID;
  String? ambulanceMedicID;
  MedicalHistoryModel? medicalHistory;
  String? hospitalGeohash;
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
    this.cancelReason,
    this.ambulanceCarID,
    this.ambulanceDriverID,
    this.ambulanceMedicID,
    this.hospitalGeohash,
  });
}
