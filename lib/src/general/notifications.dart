import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../constants/app_init_constants.dart';

final messaging = FirebaseMessaging.instance;
Future<void> initializeNotification() async {
  if (!AppInit.isWeb) {
    // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    // FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    //   if (kDebugMode) {
    //     print("Handling a foreground message: ${message.notification?.title}");
    //   }/
    //   await _initializeMessaging();
    //   await _createNotification(
    //       message.notification!, Random().nextInt(10000));
    // });
    // await messaging.getInitialMessage();
  }
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (kDebugMode) {
    print("Handling a background message: ${message.notification?.title}");
  }
}

Future<void> _createNotification(RemoteNotification message, int id) async {
  await AwesomeNotifications().createNotification(
      content: NotificationContent(
    id: id,
    channelKey: 'goambulance',
    title: message.title,
    body: message.body,
  ));
}

Future<void> _initializeMessaging() async {
  if (await AwesomeNotifications().initialize(null, [
    NotificationChannel(
        channelKey: 'goambulance',
        channelName: 'goambulance notifications',
        channelDescription: 'Notification channel for goambulance',
        defaultColor: Colors.black,
        ledColor: Colors.white)
  ])) {
    if (kDebugMode) print('awesome notification initialized');
  }

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  await AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
  });
  if (kDebugMode) {
    print('User granted permission: ${settings.authorizationStatus}');
  }
}
