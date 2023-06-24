import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:goambulance/src/general/app_init.dart';

late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
late AndroidNotificationChannel channel;
bool isFlutterLocalNotificationsInitialized = false;

void initializeNotification() async {
  await setupFlutterNotifications();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    if (kDebugMode) {
      AppInit.logger.i(
          'Handling a foreground message: ${message.notification?.body ?? 'Couldn\'t get notification body'}');
    }
    showFlutterNotification(message);
  });

  // FirebaseMessaging.instance.getInitialMessage().then(
  //       (value) =>
  // );
  // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  //   print('A new onMessageOpenedApp event was published!');
  //   Navigator.pushNamed(
  //     context,
  //     '/message',
  //     arguments: MessageArguments(message, true),
  //   );
  // });
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // await initializeFireBaseApp();
  // await setupFlutterNotifications();
  // showFlutterNotification(message);
  if (kDebugMode) {
    AppInit.logger.i(
        'Handling a background message: ${message.notification?.body ?? 'Couldn\'t get notification body'}');
  }
}

Future<void> setupFlutterNotifications() async {
  if (isFlutterLocalNotificationsInitialized) {
    return;
  }
  channel = const AndroidNotificationChannel(
    'goambulance_channel',
    'goambulance high importance channel',
    description:
        'This channel is used for goambulance important notifications.',
    importance: Importance.high,
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  isFlutterLocalNotificationsInitialized = true;
}

void showFlutterNotification(RemoteMessage message) {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  if (notification != null && android != null && !AppInit.isWeb) {
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          icon: 'notification_icon',
        ),
      ),
    );
  }
}
