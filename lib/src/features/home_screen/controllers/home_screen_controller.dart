import 'dart:async';
import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:get/get.dart';
import 'package:goambulance/firebase_files/firebase_patient_access.dart';
import 'package:goambulance/src/general/common_widgets/rounded_elevated_button.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../../../authentication/authentication_repository.dart';
import '../../../constants/enums.dart';
import '../../../general/app_init.dart';
import '../../../general/general_functions.dart';
import '../../help_center/screens/help_screen.dart';
import '../../information/screens/about_us_page.dart';
import '../../notifications/screens/notifications_screen.dart';
import '../../requests/controllers/requests_history_controller.dart';

class HomeScreenController extends GetxController {
  static HomeScreenController get instance => Get.find();

  final zoomDrawerController = ZoomDrawerController();
  bool processingSosRequest = false;
  bool shakeForSosEnabled = true;
  bool voiceForSosEnabled = true;
  bool smsForSosEnabled = true;
  final navBarIndex = 0.obs;
  StreamSubscription<AccelerometerEvent>? accelerometerSubscription;
  late final FirebasePatientDataAccess firebasePatientAccess;
  late final AuthenticationRepository authenticationRepository;

  @override
  void onReady() async {
    firebasePatientAccess = FirebasePatientDataAccess.instance;
    authenticationRepository = AuthenticationRepository.instance;
    if (authenticationRepository.criticalUserStatus.value ==
        CriticalUserStatus.criticalUserAccepted) {
      handleLocation()
          .whenComplete(() => handleSmsPermission())
          .whenComplete(() => handleNotificationsPermission())
          .whenComplete(() => handleSpeechPermission())
          .whenComplete(() => loadSosSettings())
          .whenComplete(
        () {
          if (voiceForSosEnabled) listenForSos();
        },
      ).whenComplete(
        () {
          if (shakeForSosEnabled) initShakeSos();
        },
      );
    } else {
      handleLocation()
          .whenComplete(() => handleSmsPermission())
          .whenComplete(() => handleNotificationsPermission())
          .whenComplete(() => handleSpeechPermission());
    }
    super.onReady();
  }

  void navigationBarOnTap(int navIndex) async {
    if (navIndex == 1 && Get.isRegistered<RequestsHistoryController>()) {
      RequestsHistoryController.instance.getRequestsHistory();
    }
    navBarIndex.value = navIndex;
  }

  Future<void> loadSosSettings() async {
    final getShakeSos = AppInit.prefs.getBool("shakeSOS");
    if (getShakeSos != null) {
      shakeForSosEnabled = getShakeSos;
    } else {
      shakeForSosEnabled = true;
    }
    if (kDebugMode) {
      AppInit.logger.i('Shake for sos $shakeForSosEnabled');
    }
    final getVoiceSos = AppInit.prefs.getBool("voiceSOS");
    if (getVoiceSos != null) {
      voiceForSosEnabled = getVoiceSos;
    } else {
      voiceForSosEnabled = true;
    }
    if (kDebugMode) {
      AppInit.logger.i('Voice for sos $voiceForSosEnabled');
    }
    final getSmsSOS = AppInit.prefs.getBool("smsSOS");
    if (getSmsSOS != null) {
      smsForSosEnabled = getSmsSOS;
    } else {
      smsForSosEnabled = true;
    }
    if (kDebugMode) {
      AppInit.logger.i('SMS for sos $smsForSosEnabled');
    }
  }

  Future<FunctionStatus> setShakeToSos({required bool set}) async {
    try {
      await AppInit.prefs.setBool("shakeSOS", set);
      return FunctionStatus.success;
    } catch (error) {
      if (kDebugMode) {
        AppInit.logger.e('Set error $error');
      }
      return FunctionStatus.failure;
    }
  }

  Future<FunctionStatus> setVoiceToSos({required bool set}) async {
    try {
      await AppInit.prefs.setBool("voiceSOS", set);
      voiceForSosEnabled = set;
      return FunctionStatus.success;
    } catch (error) {
      if (kDebugMode) {
        AppInit.logger.e('Set error $error');
      }
      return FunctionStatus.failure;
    }
  }

  Future<FunctionStatus> setSMSToSos({required bool set}) async {
    try {
      await AppInit.prefs.setBool("smsSOS", set);
      smsForSosEnabled = set;
      return FunctionStatus.success;
    } catch (error) {
      if (kDebugMode) {
        AppInit.logger.e('Set error $error');
      }
      return FunctionStatus.failure;
    }
  }

  Future<FunctionStatus> enableShakeToSos() async {
    try {
      final functionStatus = await setShakeToSos(set: true);
      if (functionStatus == FunctionStatus.success) {
        await accelerometerSubscription?.cancel();
        initShakeSos();
        shakeForSosEnabled = true;
        return FunctionStatus.success;
      }
    } catch (error) {
      if (kDebugMode) {
        AppInit.logger.e('Set error $error');
      }
    }
    return FunctionStatus.failure;
  }

  Future<FunctionStatus> disableShakeToSos() async {
    try {
      final functionStatus = await setShakeToSos(set: false);
      if (functionStatus == FunctionStatus.success) {
        await accelerometerSubscription?.cancel();
        shakeForSosEnabled = false;
        return FunctionStatus.success;
      }
    } catch (error) {
      if (kDebugMode) {
        AppInit.logger.e('Set error $error');
      }
    }
    return FunctionStatus.failure;
  }

  void initShakeSos() {
    accelerometerSubscription =
        accelerometerEvents.listen((AccelerometerEvent event) {
      double magnitude =
          sqrt(pow(event.x, 2) + pow(event.y, 2) + pow(event.z, 2));
      if (magnitude > 25) {
        if (kDebugMode) print('Device is shaking');
        sosRequest(pressed: false);
      }
    });
  }

  void listenForSos() async {
    if (authenticationRepository.criticalUserStatus.value ==
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
          listenFor: const Duration(seconds: 10),
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

  Future<void> textToSpeech({required String text}) async {
    FlutterTts flutterTts = FlutterTts();

    await flutterTts.setLanguage(isLangEnglish() ? 'en' : 'ar');

    await flutterTts.speak(text);
  }

  void showSosAlertDialogue({required GeoPoint requestLocation}) async {
    if (Get.context != null) {
      textToSpeech(text: 'sosRequestCountTTS'.tr);
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
                        duration: 10,
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
                          onPressed: () {
                            processingSosRequest = false;
                            Get.back();
                          },
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
    if (!processingSosRequest) {
      processingSosRequest = true;
      if (pressed) showLoadingScreen();

      firebasePatientAccess
          .checkUserHasSosRequest()
          .then((hasSosRequest) async {
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
                  AppInit.logger
                      .e('Location get error trying sos using primary');
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
            textToSpeech(text: 'hasSosRequest'.tr)
                .whenComplete(() => processingSosRequest = false);
          }
        } else {
          if (pressed) hideLoadingScreen();
        }
      });
    }
  }

  void sendSosPrimaryAddress({required bool pressed}) async {
    final primaryAddressLocation =
        await FirebasePatientDataAccess.instance.getPrimaryAddressLocation();
    if (pressed) hideLoadingScreen();
    if (primaryAddressLocation != null) {
      showSosAlertDialogue(requestLocation: primaryAddressLocation);
    } else {
      processingSosRequest = false;
      showSnackBar(
          text: 'sosRequestInitFailed'.tr, snackBarType: SnackBarType.error);
      textToSpeech(text: 'sosRequestInitFailedTTS'.tr);
    }
  }

  void sendSosRequest({required GeoPoint requestLocation}) =>
      firebasePatientAccess
          .makeSosRequest(requestLocation: requestLocation)
          .then((sosRequestId) {
        if (sosRequestId != null) {
          processingSosRequest = false;
          showSnackBar(
              text: 'sosRequestSent'.tr, snackBarType: SnackBarType.success);
          textToSpeech(text: 'sosRequestSentTTS'.tr);
          if (smsForSosEnabled && !AppInit.isWeb) {
            sendRequestSms(
                requestId: sosRequestId,
                patientName: authenticationRepository.userInfo.name,
                sosSmsType: SosSmsType.sosRequestSMS);
          }
        } else {
          processingSosRequest = false;
          showSnackBar(
              text: 'sosRequestSendFailed'.tr,
              snackBarType: SnackBarType.error);
          textToSpeech(text: 'sosRequestSendFailedTTS'.tr);
        }
      });

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
          // () => const TestNav1(),
          () => const NotificationsScreen(),
          transition: getPageTransition(),
        );
        break;
      case 1:
        displayChangeLang();
        break;
      case 2:
        Get.to(
          () => const HelpScreen(),
          transition: getPageTransition(),
        );
        break;
      case 3:
        Get.to(
          () => const AboutUsScreen(),
          transition: getPageTransition(),
        );
        break;
      default:
        break;
    }
  }

  void toggleDrawer() {
    zoomDrawerController.toggle?.call();
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
    'ساعدونى',
    'مساعدة',
    'معونة ',
    'إنقاذ',
    'تنبيه',
    'الأمن',
    'النجدة'
  ];
  @override
  void onClose() async {
    await accelerometerSubscription?.cancel();
    await accelerometerEvents.drain();
    super.onClose();
  }
}
