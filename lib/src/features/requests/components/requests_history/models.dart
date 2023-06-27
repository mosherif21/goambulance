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

class RequestDataModel {
  final String requestId;
  final String userId;
  final String additionalInformation;
  String hospitalId;
  String hospitalName;
  final String backupNumber;
  final String patientCondition;
  RxString mapUrl = ''.obs;
  final String requestDateTime;
  RequestStatus requestStatus;
  final bool isUser;
  final LatLng requestLocation;
  LatLng hospitalLocation;
  Timestamp timestamp;
  String? cancelReason;
  String? ambulanceCarID;
  String? ambulanceDriverID;
  String? ambulanceMedicID;
  MedicalHistoryModel? medicalHistory;
  String? hospitalGeohash;
  RequestDataModel({
    required this.requestId,
    required this.userId,
    required this.backupNumber,
    required this.patientCondition,
    required this.isUser,
    required this.hospitalId,
    required this.timestamp,
    required this.hospitalName,
    required this.requestDateTime,
    required this.requestStatus,
    required this.requestLocation,
    required this.hospitalLocation,
    required this.additionalInformation,
    this.cancelReason,
    this.ambulanceCarID,
    this.ambulanceDriverID,
    this.ambulanceMedicID,
    this.hospitalGeohash,
  });
}
