import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:goambulance/authentication/authentication_repository.dart';
import 'package:goambulance/firebase_files/firebase_patient_access.dart';
import 'package:goambulance/src/constants/enums.dart';
import 'package:goambulance/src/features/home_screen/controllers/home_screen_controller.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../constants/no_localization_strings.dart';
import '../../../general/app_init.dart';
import '../../../general/general_functions.dart';
import '../../../general/map_utils.dart';
import '../components/requests_history/components/request_details_page.dart';
import '../components/requests_history/models.dart';
import '../components/tracking_request/components/tracking_request_page.dart';

class RequestsHistoryController extends GetxController {
  static RequestsHistoryController get instance => Get.find();

  final requestLoaded = false.obs;
  final requestsList = <RequestHistoryModel>[].obs;
  late final String userId;
  late final DocumentReference firestoreUserRef;
  late final FirebaseFirestore _firestore;
  late final FirebasePatientDataAccess firebasePatientDataAccess;
  final requestsRefreshController = RefreshController(initialRefresh: false);
  late final StreamSubscription<QuerySnapshot<Map<String, dynamic>>>?
      sosRequestSubscription;
  final hasSosRequest = false.obs;

  @override
  void onReady() async {
    userId = AuthenticationRepository.instance.fireUser.value!.uid;
    _firestore = FirebaseFirestore.instance;
    firestoreUserRef = _firestore.collection('users').doc(userId);
    firebasePatientDataAccess = FirebasePatientDataAccess.instance;
    getRequestsHistory();
    listenForSosRequest();
    super.onReady();
  }

  void onRefresh() async {
    getRequestsHistory();
    requestsRefreshController.refreshToIdle();
    requestsRefreshController.resetNoData();
  }

  void listenForSosRequest() {
    try {
      final userId = AuthenticationRepository.instance.fireUser.value!.uid;
      sosRequestSubscription = FirebaseFirestore.instance
          .collection('sosRequests')
          .where('userId', isEqualTo: userId)
          .snapshots()
          .listen((QuerySnapshot snapshot) {
        if (snapshot.docs.isNotEmpty) {
          hasSosRequest.value = true;
        } else {
          if (hasSosRequest.value) {
            Future.delayed(const Duration(seconds: 1)).whenComplete(() {
              if (!hasSosRequest.value &&
                  HomeScreenController.instance.homeBottomNavController.index ==
                      1) {
                getRequestsHistory();
              }
            });
          }
          hasSosRequest.value = false;
        }
      });
    } on FirebaseException catch (error) {
      if (kDebugMode) {
        AppInit.logger.e(error.toString());
      }
    } catch (err) {
      if (kDebugMode) {
        AppInit.logger.e(err.toString());
      }
    }
  }

  void cancelSosRequest() async {
    showLoadingScreen();
    final functionStatus =
        await FirebasePatientDataAccess.instance.cancelSosRequest();
    hideLoadingScreen();
    if (functionStatus == FunctionStatus.success) {
      hasSosRequest.value = false;
      showSnackBar(
          text: 'sosRequestCanceledSuccessfully'.tr,
          snackBarType: SnackBarType.success);
    } else {
      showSnackBar(
          text: 'sosRequestCanceledFailed'.tr,
          snackBarType: SnackBarType.error);
    }
  }

  void getRequestsHistory() async {
    try {
      requestLoaded.value = false;
      final trace =
          FirebasePerformance.instance.newTrace('load_recent_requests');
      await trace.start();
      final gotRequests = await firebasePatientDataAccess.getRecentRequests();
      await trace.stop();
      if (gotRequests != null) {
        requestsList.value = gotRequests;
        if (kDebugMode) {
          AppInit.logger
              .i('loaded requests history, no: ${requestsList.length}');
        }
      } else {
        showSnackBar(
            text: 'errorOccurred'.tr, snackBarType: SnackBarType.error);
        if (kDebugMode) {
          AppInit.logger.e('Failed to get requests');
        }
      }

      requestLoaded.value = true;
      for (int index = 0; index < requestsList.length; index++) {
        if (requestsList[index].requestStatus == RequestStatus.pending ||
            requestsList[index].requestStatus == RequestStatus.accepted) {
          getStaticMapImgURL(
            marker1IconUrl: requestMarkerImageUrl,
            marker1LatLng: requestsList[index].requestLocation,
            marker1TitleIconUrl:
                isLangEnglish() ? requestEngImageUrl : requestArImageUrl,
            marker2IconUrl: hospitalMarkerImageUrl,
            marker2LatLng: requestsList[index].hospitalLocation,
            marker2TitleIconUrl:
                isLangEnglish() ? hospitalEngImageUrl : hospitalArImageUrl,
            sizeWidth: 350,
            sizeHeight: 200,
          ).then((mapImgUrl) => requestsList[index].mapUrl.value = mapImgUrl);
        } else if (requestsList[index].requestStatus ==
            RequestStatus.assigned) {
          firebasePatientDataAccess
              .getAmbulanceLocation(
                  ambulanceDriverId: requestsList[index].ambulanceDriverID!)
              .then(
            (ambulanceLocation) {
              getStaticMapImgURL(
                marker1IconUrl: requestMarkerImageUrl,
                marker1LatLng: requestsList[index].requestLocation,
                marker1TitleIconUrl:
                    isLangEnglish() ? requestEngImageUrl : requestArImageUrl,
                marker2IconUrl: ambulanceLocation != null
                    ? ambulanceMarkerImageUrl
                    : hospitalMarkerImageUrl,
                marker2LatLng:
                    ambulanceLocation ?? requestsList[index].hospitalLocation,
                marker2TitleIconUrl: isLangEnglish()
                    ? ambulanceLocation != null
                        ? ambulanceEngImageUrl
                        : hospitalEngImageUrl
                    : ambulanceLocation != null
                        ? ambulanceArImageUrl
                        : hospitalArImageUrl,
                sizeWidth: 350,
                sizeHeight: 200,
              ).then(
                  (mapImgUrl) => requestsList[index].mapUrl.value = mapImgUrl);
            },
          );
        } else if (requestsList[index].requestStatus == RequestStatus.ongoing) {
          firebasePatientDataAccess
              .getAmbulanceLocation(
                  ambulanceDriverId: requestsList[index].ambulanceDriverID!)
              .then(
            (ambulanceLocation) {
              getStaticMapImgURL(
                marker1IconUrl: ambulanceLocation != null
                    ? ambulanceMarkerImageUrl
                    : requestMarkerImageUrl,
                marker1LatLng:
                    ambulanceLocation ?? requestsList[index].requestLocation,
                marker1TitleIconUrl: isLangEnglish()
                    ? ambulanceLocation != null
                        ? ambulanceEngImageUrl
                        : requestEngImageUrl
                    : ambulanceLocation != null
                        ? ambulanceArImageUrl
                        : requestArImageUrl,
                marker2IconUrl: hospitalMarkerImageUrl,
                marker2LatLng: requestsList[index].hospitalLocation,
                marker2TitleIconUrl:
                    isLangEnglish() ? hospitalEngImageUrl : hospitalArImageUrl,
                sizeWidth: 350,
                sizeHeight: 200,
              ).then(
                  (mapImgUrl) => requestsList[index].mapUrl.value = mapImgUrl);
            },
          );
        }
      }
    } on FirebaseException catch (error) {
      if (kDebugMode) {
        AppInit.logger.e(error.toString());
      }
    } catch (err) {
      if (kDebugMode) {
        AppInit.logger.e(err.toString());
      }
    }
  }

  void onRequestSelected(
      {required RequestHistoryModel initialRequestModel}) async {
    if (kDebugMode) {
      AppInit.logger.i('known status: ${initialRequestModel.requestStatus}');
    }
    final initialKnownStatus = initialRequestModel.requestStatus;
    if (initialRequestModel.requestStatus == RequestStatus.completed ||
        initialRequestModel.requestStatus == RequestStatus.canceled) {
      Get.to(() => RequestDetailsPage(requestModel: initialRequestModel),
          transition: getPageTransition());
    } else {
      showLoadingScreen();
      final latestRequestModel = await firebasePatientDataAccess
          .getRequestStatus(requestModel: initialRequestModel);
      hideLoadingScreen();
      if (latestRequestModel != null) {
        final latestRequestStatus = latestRequestModel.requestStatus;
        if (kDebugMode) {
          AppInit.logger.i('after check status: $latestRequestStatus');
        }
        if (latestRequestStatus == RequestStatus.pending ||
            latestRequestStatus == RequestStatus.accepted ||
            latestRequestStatus == RequestStatus.assigned ||
            latestRequestStatus == RequestStatus.ongoing) {
          Get.to(() => TrackingRequestPage(requestModel: latestRequestModel),
              transition: getPageTransition());
        } else {
          Get.to(() => RequestDetailsPage(requestModel: latestRequestModel),
              transition: getPageTransition());
        }
        if (initialKnownStatus != latestRequestStatus) {
          // latestRequestModel.hospitalId != initialRequestModel.hospitalId) {
          getRequestsHistory();
        }
      } else {
        if (initialRequestModel.patientCondition == 'sosRequest') {
          showSnackBar(
              text: 'sosRequestHospitalMaybeCanceled'.tr,
              snackBarType: SnackBarType.error);
          getRequestsHistory();
        } else {
          showSnackBar(
              text: 'errorOccurred'.tr, snackBarType: SnackBarType.error);
        }
      }
    }
  }

  @override
  void onClose() {
    requestsRefreshController.dispose();
    sosRequestSubscription?.cancel();
    super.onClose();
  }
}
