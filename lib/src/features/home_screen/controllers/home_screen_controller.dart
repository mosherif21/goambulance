import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:get/get.dart';
import 'package:goambulance/firebase_files/firebase_patient_access.dart';
import 'package:goambulance/src/features/account/screens/account_screen.dart';
import 'package:goambulance/src/features/notifications/screens/notifications_screen.dart';
import 'package:goambulance/src/features/payment/screens/payment_screen.dart';
import 'package:goambulance/src/features/requests/components/making_request/models.dart';
import 'package:goambulance/src/features/requests/controllers/requests_history_controller.dart';
import 'package:goambulance/src/general/common_widgets/rounded_elevated_button.dart';
import 'package:line_icons/line_icon.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../../../authentication/authentication_repository.dart';
import '../../../constants/enums.dart';
import '../../../general/app_init.dart';
import '../../../general/general_functions.dart';
import '../../help_center/screens/help_screen.dart';
import '../../home_dashboard/screens/home_dashboard.dart';
import '../../information/screens/about_us_page.dart';
import '../../requests/screens/previous_requests_page.dart';

class HomeScreenController extends GetxController {
  static HomeScreenController get instance => Get.find();

  final homeBottomNavController = PersistentTabController(initialIndex: 0);
  final zoomDrawerController = ZoomDrawerController();
  final carouselController = CarouselController();

  @override
  void onReady() async {
    if (AuthenticationRepository.instance.criticalUserStatus.value ==
        CriticalUserStatus.criticalUserAccepted) {
      handleLocation()
          .whenComplete(() => handleSmsPermission())
          .whenComplete(() => handleNotificationsPermission())
          .whenComplete(() => handleSpeechPermission())
          .whenComplete(() => listenForSos());
    } else {
      handleLocation()
          .whenComplete(() => handleSmsPermission())
          .whenComplete(() => handleNotificationsPermission())
          .whenComplete(() => handleSpeechPermission());
    }

    homeBottomNavController.addListener(() {
      if (homeBottomNavController.index == 1 &&
          Get.isRegistered<RequestsHistoryController>()) {
        RequestsHistoryController.instance.getRequestsHistory();
      }
    });
    super.onReady();
  }

  void listenForSos() async {
    if (AuthenticationRepository.instance.criticalUserStatus.value ==
        CriticalUserStatus.criticalUserAccepted) {
      final speechToText = SpeechToText();
      bool available = await speechToText.initialize(onStatus: (status) {
        if (kDebugMode) {
          AppInit.logger.i('Speech status $status');
        }
      }, onError: (error) {
        if (kDebugMode) {
          AppInit.logger.e('Speech error $error');
        }
      });
      if (available) {
        await speechToText.listen(
          listenMode: ListenMode.dictation,
          localeId: Get.locale?.languageCode,
          listenFor: const Duration(seconds: 5),
          onResult: (listenedText) async {
            if (listenedText.finalResult) {
              final listenedString = listenedText.recognizedWords.toLowerCase();
              bool containsEmergencyWord = false;
              for (String word in emergencyWords) {
                if (listenedString.contains(word.toLowerCase())) {
                  containsEmergencyWord = true;
                  break;
                }
              }
              if (containsEmergencyWord) {
                sosRequest(pressed: false);
              }
            }
          },
        );
      }
    }
  }

  void showSosAlertDialogue({required GeoPoint requestLocation}) {
    if (Get.context != null) {
      showDialog(
        context: Get.context!,
        builder: (BuildContext context) {
          final screenHeight = getScreenHeight(context);
          return Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: WillPopScope(
              onWillPop: () {
                return Future.value(false);
              },
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(15),
                  height: screenHeight * 0.4,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 5),
                      AutoSizeText(
                        'sosRequestCount'.tr,
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.w800,
                        ),
                        maxLines: 2,
                      ),
                      const SizedBox(height: 20),
                      CircularCountDownTimer(
                        duration: 5,
                        initialDuration: 0,
                        width: 150,
                        height: screenHeight * 0.2,
                        ringColor: Colors.grey[300]!,
                        ringGradient: null,
                        fillColor: Colors.black,
                        fillGradient: null,
                        backgroundColor: Colors.white,
                        backgroundGradient: null,
                        strokeWidth: 20.0,
                        strokeCap: StrokeCap.round,
                        textStyle: const TextStyle(
                            fontSize: 33.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                        textFormat: CountdownTextFormat.S,
                        isReverse: true,
                        isReverseAnimation: true,
                        isTimerTextShown: true,
                        autoStart: true,
                        onStart: () {},
                        onComplete: () {
                          Get.back();
                          sendSosRequest(requestLocation: requestLocation);
                        },
                        onChange: (String timeStamp) {},
                        timeFormatterFunction:
                            (defaultFormatterFunction, duration) {
                          return Function.apply(
                              defaultFormatterFunction, [duration]);
                        },
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: RoundedElevatedButton(
                          buttonText: 'cancel'.tr,
                          onPressed: () => Get.back(),
                          enabled: true,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    }
  }

  void sosRequestPress() =>
      handleLocation().whenComplete(() => sosRequest(pressed: true));

  void sosRequest({required bool pressed}) {
    if (pressed) showLoadingScreen();
    final firebasePatientAccess = FirebasePatientDataAccess.instance;
    firebasePatientAccess.checkUserHasSosRequest().then((hasSosRequest) async {
      if (hasSosRequest != null) {
        if (!hasSosRequest) {
          final locationPermissionGranted =
              await Permission.location.status.isGranted;
          final locationServiceEnabled = await Location().serviceEnabled();
          if (locationPermissionGranted && locationServiceEnabled) {
            try {
              final currentLocation =
                  await geolocator.Geolocator.getCurrentPosition(
                      desiredAccuracy: geolocator.LocationAccuracy.high,
                      timeLimit: const Duration(seconds: 10));
              if (kDebugMode) {
                print(
                    'current location for sos Request ${currentLocation.latitude.toString()}, ${currentLocation.longitude.toString()}');
              }
              if (pressed) hideLoadingScreen();
              showSosAlertDialogue(
                  requestLocation: GeoPoint(
                      currentLocation.latitude, currentLocation.longitude));
            } on TimeoutException catch (_) {
              if (kDebugMode) {
                AppInit.logger
                    .e('Location get timed out trying sos using primary');
              }
              sendSosPrimaryAddress(pressed: pressed);
            } on geolocator.LocationServiceDisabledException catch (_) {
              if (kDebugMode) {
                AppInit.logger.e('Location get error trying sos using primary');
              }
              sendSosPrimaryAddress(pressed: pressed);
            }
          } else {
            sendSosPrimaryAddress(pressed: pressed);
          }
        } else {
          if (pressed) hideLoadingScreen();
          showSnackBar(
              text: 'hasSosRequest'.tr, snackBarType: SnackBarType.error);
        }
      } else {
        if (pressed) hideLoadingScreen();
      }
    });
  }

  void sendSosPrimaryAddress({required bool pressed}) async {
    final primaryAddressLocation =
        await FirebasePatientDataAccess.instance.getPrimaryAddressLocation();
    if (pressed) hideLoadingScreen();
    if (primaryAddressLocation != null) {
      showSosAlertDialogue(requestLocation: primaryAddressLocation);
    } else {
      showSnackBar(
          text: 'sosRequestInitFailed'.tr, snackBarType: SnackBarType.error);
    }
  }

  void sendSosRequest({required GeoPoint requestLocation}) async {
    final firebasePatientDataAccess = FirebasePatientDataAccess.instance;
    final authRep = AuthenticationRepository.instance;
    final sosRequest = SosRequestModel(
      userId: authRep.fireUser.value!.uid,
      requestLocation: requestLocation,
    );
    firebasePatientDataAccess
        .sosRequest(sosRequestInfo: sosRequest)
        .then((functionStatus) {
      if (functionStatus == FunctionStatus.success) {
        showSnackBar(
            text: 'sosRequestSent'.tr, snackBarType: SnackBarType.success);
      } else {
        showSnackBar(
            text: 'sosRequestSendFailed'.tr, snackBarType: SnackBarType.error);
      }
    });
  }

  bool isDrawerOpen(DrawerState drawerState) =>
      drawerState == DrawerState.open ||
              drawerState == DrawerState.opening ||
              drawerState == DrawerState.closing
          ? true
          : false;

  void onDrawerItemSelected(int index) {
    switch (index) {
      case 0:
        Get.to(
          () => const PaymentScreen(),
          transition: getPageTransition(),
        );
        break;
      case 1:
        Get.to(
          () => const NotificationsScreen(),
          transition: getPageTransition(),
        );
        break;
      case 2:
        displayChangeLang();
        break;
      case 3:
        Get.to(
          () => const HelpScreen(),
          transition: getPageTransition(),
        );
        break;
      case 4:
        Get.to(
          () => const AboutUsScreen(),
          transition: getPageTransition(),
        );
        break;
    }
  }

  void toggleDrawer() {
    zoomDrawerController.toggle?.call();
  }

  List<Widget> buildScreens() {
    return [
      const HomeDashBoard(),
      const PreviousRequestsPage(),
      const AccountScreen(),
    ];
  }

  List<PersistentBottomNavBarItem> navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: LineIcon.home(),
        title: ('home'.tr),
        activeColorPrimary: Colors.black,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: LineIcon.history(),
        title: ('requests'.tr),
        activeColorPrimary: Colors.black,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.account_circle_outlined),
        title: ('account'.tr),
        activeColorPrimary: Colors.black,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
    ];
  }

  final emergencyWords = [
    'mayday',
    'ambulance',
    'sos',
    'emergency',
    'distress',
    'help',
    'urgent',
    'crisis',
    'danger',
    'طوارئ',
    'انقذوني',
    'استغاثة',
    'اسعاف',
    'مساعدة',
    'معونة ',
    'إنقاذ',
    'تنبيه',
    'الأمن',
    'النجدة'
  ];
  @override
  void onClose() {
    homeBottomNavController.dispose();
    super.onClose();
  }
}
