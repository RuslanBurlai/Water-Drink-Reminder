import 'dart:convert';
import 'dart:developer';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:water_drink_reminder/core/constants.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  log("Handling a background message: ${message.messageId}");
  log('Title: ${message.notification?.title})');
  log('Body: ${message.notification?.body})');
  log('Payload: ${message.data})');
}

@pragma('vm:entry-point')
void _flutterLocalNotificationsHandler(NotificationResponse details) {
  final message = RemoteMessage.fromMap(jsonDecode(details.payload!));

  log('Title: ${message.notification?.title})');
  log('Body: ${message.notification?.body})');
  log('Payload: ${message.data})');
}

class FireBaseNotofication {
  final _firebaseInstance = FirebaseMessaging.instance;
  final _androidChannel = const AndroidNotificationChannel(
      'water_reminder', 'water_reminder_notification',
      description: 'Reminding to water drink',
      importance: Importance.defaultImportance);
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  String? selectedNotificationPayload;

  Future<void> initNotifications() async {
    await _firebaseInstance.requestPermission();
    final fCMToken = await _firebaseInstance.getToken();
    log('Token: $fCMToken');
    await initLocalNotification();
    await initPushNotifications();
  }

  Future<void> initLocalNotification() async {
    tz.initializeTimeZones();
    const iOS = DarwinInitializationSettings();
    const android = AndroidInitializationSettings('@drawable/ic_launcher');
    const settings = InitializationSettings(android: android, iOS: iOS);

    _flutterLocalNotificationsPlugin.initialize(
      settings,
      onDidReceiveBackgroundNotificationResponse:
          _flutterLocalNotificationsHandler,
      onDidReceiveNotificationResponse: _flutterLocalNotificationsHandler,
    );
    
    final platform =
        _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(_androidChannel);
  }

  Future<void> initPushNotifications() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen((message) async {
      final notification = message.notification;
      if (notification == null) return;

      await _flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
              android: AndroidNotificationDetails(
                  _androidChannel.id, _androidChannel.name,
                  channelDescription: _androidChannel.description, icon: null)),
          payload: jsonEncode(message.toMap()));
    });
  }

  Future<void> scheduledNotification(Duration duration, int count) async {
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
    var timeNow = tz.TZDateTime.now(tz.local);

    for (var i = 1; i <= count; i++) {
      await _flutterLocalNotificationsPlugin.zonedSchedule(
        i,
        'Water drink reminder',
        'Drink some water',
        timeNow.add(duration * i),
        NotificationDetails(
            android: AndroidNotificationDetails(
                _androidChannel.id, _androidChannel.name,
                channelDescription: _androidChannel.description)),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: 'Save your goals, push the circle button',
      );
    }
  }

  void handleMessage(RemoteMessage? message) {
    if (message == null) return;

    log('Title: ${message.notification?.title})');
    log('Body: ${message.notification?.body})');
    log('Payload: ${message.data})');
  }

  Future<void> disableAllNotification() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

  void disableNotification(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<Map<String, String?>> fetchInitialRoute() async {
    final NotificationAppLaunchDetails? notificationAppLaunchDetails =
        await _flutterLocalNotificationsPlugin
            .getNotificationAppLaunchDetails();
    String initialRoute = loginPageRoute;
    if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
      selectedNotificationPayload =
          notificationAppLaunchDetails!.notificationResponse?.payload;
      initialRoute = homePageRoute;
    }
    return {initialRoute: selectedNotificationPayload};
  }
}
