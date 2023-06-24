import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:goambulance/src/general/app_init.dart';

void initializeNotification() {
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (kDebugMode) {
      AppInit.logger
          .i('Handling a foreground message: ${message.notification?.title}');
    }
    _initializeMessaging().whenComplete(() =>
        _createNotification(message.notification!, Random().nextInt(10000)));
  });
  // await messaging.getInitialMessage();
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // if (kDebugMode) {
  //   AppInit.logger.i('Handling a background message: ${message.data['title']}');
  // }
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
    if (kDebugMode) {
      AppInit.logger.i('awesome notification initialized');
    }
  }

  NotificationSettings settings =
      await FirebaseMessaging.instance.requestPermission(
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
  await AwesomeNotifications().isNotificationAllowed().then((isAllowed) async {
    if (!isAllowed) {
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }
  });

  if (kDebugMode) {
    AppInit.logger
        .d('User granted permission: ${settings.authorizationStatus}');
  }
}
