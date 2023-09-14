import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:goambulance/authentication/authentication_repository.dart';
import 'package:goambulance/firebase_files/firebase_patient_access.dart';
import 'package:goambulance/src/constants/enums.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../constants/no_localization_strings.dart';
import '../../../general/app_init.dart';
import '../../../general/general_functions.dart';
import '../../../general/map_utils.dart';
import '../../home_screen/controllers/home_screen_controller.dart';
import '../components/models.dart';
import '../components/requests_history/request_details_page.dart';
import '../components/tracking_request/tracking_request_page.dart';

class RequestsHistoryController extends GetxController {
  static RequestsHistoryController get instance => Get.find();

  final requestsLoaded = false.obs;
  final requestsList = <RequestHistoryDataModel>[].obs;
  late final String userId;
  late final DocumentReference firestoreUserRef;
  late final FirebaseFirestore _firestore;
  late final FirebasePatientDataAccess firebasePatientDataAccess;
  late final HomeScreenController homeScreenController;
  final requestsRefreshController = RefreshController(initialRefresh: false);
  late final StreamSubscription<QuerySnapshot<Map<String, dynamic>>>?
      sosRequestSubscription;
  late final StreamSubscription<QuerySnapshot<Map<String, dynamic>>>?
      sentSosRequestSubscription;
  final hasSosRequest = false.obs;
  bool hasSentSosRequest = false;

  @override
  void onReady() {
    userId = AuthenticationRepository.instance.fireUser.value!.uid;
    _firestore = FirebaseFirestore.instance;
    firestoreUserRef = _firestore.collection('users').doc(userId);
    firebasePatientDataAccess = FirebasePatientDataAccess.instance;
    homeScreenController = HomeScreenController.instance;
    getRequestsHistory();
    if (isUserCritical()) {
      listenForSosRequest();
      listenForSentSosRequests();
    }
    super.onReady();
  }

  void onRefresh() {
    getRequestsHistory();
    requestsRefreshController.refreshToIdle();
    requestsRefreshController.resetNoData();
  }

  void listenForSentSosRequests() {
    try {
      final userId = AuthenticationRepository.instance.fireUser.value!.uid;
      sentSosRequestSubscription = FirebaseFirestore.instance
          .collection('pendingRequests')
          .where('userId', isEqualTo: userId)
          .where('patientCondition', isEqualTo: "sosRequest")
          .snapshots()
          .listen((QuerySnapshot snapshot) {
        if (snapshot.docs.isNotEmpty) {
          if (requestsLoaded.value &&
              homeScreenController.navBarIndex.value == 1) {
            getRequestsHistory();
          }
          hasSentSosRequest = true;
        } else {
          if (hasSentSosRequest &&
              homeScreenController.navBarIndex.value == 1) {
            getRequestsHistory();
          }
          hasSentSosRequest = false;
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
      requestsLoaded.value = false;
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

      requestsLoaded.value = true;
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
      {required RequestHistoryDataModel initialRequestModel}) async {
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
      final trace =
          FirebasePerformance.instance.newTrace('get_last_request_updates');
      await trace.start();
      final latestRequestModel = await firebasePatientDataAccess
          .getRequestStatus(requestModel: initialRequestModel);
      await trace.stop();
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
          final result = await Get.to(
              () => TrackingRequestPage(requestModel: latestRequestModel),
              transition: getPageTransition());
          if (result == 'sosCancelReturn') {
            showSnackBar(
                text: 'sosCancelReturn'.tr, snackBarType: SnackBarType.error);
          }
          if (latestRequestModel.patientCondition != 'sosRequest') {
            getRequestsHistory();
          }
        } else {
          await Get.to(
              () => RequestDetailsPage(requestModel: latestRequestModel),
              transition: getPageTransition());
          if (initialKnownStatus != latestRequestStatus) {
            getRequestsHistory();
          }
        }
      } else {
        if (initialRequestModel.patientCondition == 'sosRequest') {
          showSnackBar(
              text: 'sosRequestHospitalCanceled'.tr,
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
  void onClose() async {
    if (isUserCritical()) {
      await sosRequestSubscription?.cancel();
      await sentSosRequestSubscription?.cancel();
    }
    requestsRefreshController.dispose();
    super.onClose();
  }
}
