import 'dart:ui';

import 'package:evf/environment.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationProvider {
  FlutterLocalNotificationsPlugin? _localNotifications;

  NotificationProvider();

  Future<void> initializePlatformNotifications() async {
    try {
      _localNotifications = FlutterLocalNotificationsPlugin();
      Environment.debug("requesting permissions");
      _localNotifications!
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();

      const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('evflogo');

      const InitializationSettings initializationSettings =
          InitializationSettings(android: initializationSettingsAndroid);

      Environment.debug("initializing localNotifications");
      await _localNotifications!.initialize(initializationSettings);
      Environment.debug("end of initialization");
    } catch (e) {
      Environment.debug("on notification init, caught $e");
    }
  }

  Future handleMessage(RemoteMessage msg) async {
    Environment.debug("handling remote message ${msg.messageId}");
    await showLocalNotification(
        id: msg.notification.hashCode,
        title: msg.notification?.title ?? '',
        body: msg.notification?.body ?? '',
        payload: '');
  }

  Future<NotificationDetails> _notificationDetails() async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'channel id',
      'channel name',
      groupKey: 'com.example.flutter_push_notifications',
      channelDescription: 'channel description',
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
      ticker: 'ticker',
      color: Color(0xff2196f3),
    );
    //await _localNotifications!.getNotificationAppLaunchDetails();
    return NotificationDetails(android: androidPlatformChannelSpecifics);
  }

  Future<void> showLocalNotification({
    required int id,
    required String title,
    required String body,
    required String payload,
  }) async {
    final platformChannelSpecifics = await _notificationDetails();
    await _localNotifications!.show(
      id,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }
}
