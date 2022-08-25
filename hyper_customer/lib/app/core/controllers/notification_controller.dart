import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:hyper_customer/app/data/repository/repository.dart';
import 'package:hyper_customer/app/modules/account/controllers/account_controller.dart';
import 'package:hyper_customer/app/modules/activity/controllers/activity_controller.dart';
import 'package:hyper_customer/app/modules/home/controllers/home_controller.dart';
import 'package:hyper_customer/app/modules/package/controllers/package_controller.dart';
import 'package:hyper_customer/app/network/dio_token_manager.dart';
import 'package:hyper_customer/app/modules/notification/controllers/notification_controller.dart'
    as nt;

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

    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
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
                channel.id + '.123',
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

        loadAll();
      },
    );

    // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  late HomeController _homeController;
  late PackageController _packageController;
  late ActivityController _activityController;
  late AccountController _accountController;

  void loadAll() {
    Get.put(
      HomeController(),
      permanent: true,
    );
    _homeController = Get.find<HomeController>();
    _homeController.init();

    Get.put(
      PackageController(),
      permanent: true,
    );
    _packageController = Get.find<PackageController>();
    _packageController.init();

    Get.put(
      ActivityController(),
      permanent: true,
    );
    _activityController = Get.find<ActivityController>();
    _activityController.init();

    Get.put(
      AccountController(),
      permanent: true,
    );
    _accountController = Get.find<AccountController>();
    _accountController.init();
  }

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    debugPrint(
        "Notification: Handling a background message: ${message.messageId}");
  }

  Future<void> registerNotification() async {
    Repository repository = Get.find(tag: (Repository).toString());
    final String fcmToken = await FirebaseMessaging.instance.getToken() ?? '';
    final String customerId = TokenManager.instance.user?.customerId ?? '';

    var registerNotificationService = repository.registerNotification(
      customerId,
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
    final String customerId = TokenManager.instance.user?.customerId ?? '';

    var registerNotificationService = repository.registerNotification(
      customerId,
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
