import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:hyper_driver/app/data/repository/repository.dart';
import 'package:hyper_driver/app/network/dio_token_manager.dart';

import '../../../config/firebase_options.dart';

class NotificationController {
  static final NotificationController _instance =
      NotificationController._internal();
  static NotificationController get instance => _instance;
  NotificationController._internal();

  AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'hyper.notification.', // id
    'Hyper Notification', // title
    description: 'Hyper Copy Right', // description
    importance: Importance.max,
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      debugPrint('Notification: Foreground message received');

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id + '.124',
              channel.name,
              sound: const RawResourceAndroidNotificationSound(
                'sound_notification',
              ),
              channelDescription: channel.description,
              importance: Importance.max,
              priority: Priority.high,
              icon: 'mipmap/ic_launcher',
            ),
          ),
        );
      }
    });

    // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    debugPrint(
        "Notification: Handling a background message: ${message.messageId}");
  }

  Future<void> registerNotification() async {
    Repository repository = Get.find(tag: (Repository).toString());
    final String fcmToken = await FirebaseMessaging.instance.getToken() ?? '';
    final String driverId = TokenManager.instance.user?.driverId ?? '';

    var registerNotificationService = repository.registerNotification(
      driverId,
      fcmToken,
    );

    try {
      await registerNotificationService;
      debugPrint('Notification: fcmToken: $fcmToken');
    } catch (error) {
      debugPrint('Notification: Can not register');
      rethrow;
    }
  }

  Future<void> unregisterNotification() async {
    Repository repository = Get.find(tag: (Repository).toString());
    final String driverId = TokenManager.instance.user?.driverId ?? '';

    var registerNotificationService = repository.registerNotification(
      driverId,
      'null',
    );

    try {
      await registerNotificationService;
      debugPrint('Notification: unregister successfully');
    } catch (error) {
      debugPrint('Notification: Can not unregister');
      rethrow;
    }
  }
}
