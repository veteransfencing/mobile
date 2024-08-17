import 'dart:io';

import 'package:evf/environment.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:evf/providers/notification_provider.dart';

class FCM {
  static Future initialise() async {
    if (Platform.isAndroid || Platform.isIOS) {
      await Firebase.initializeApp(options: Environment.instance.flavor.fcm);
      await Environment.instance.notificationProvider.initializePlatformNotifications();
    }
  }

  static Future postInitialise() async {
    if (Platform.isAndroid || Platform.isIOS) {
      //await notificationProvider.initializePlatformNotifications();
      Environment.debug("android or ios, starting firebase");

      // according to the documentation, not required for Android
      var notificationSettings = await FirebaseMessaging.instance.requestPermission(
        alert: true,
        provisional: true,
      );
      Environment.debug("permissions: ${notificationSettings.authorizationStatus}");

      Environment.instance.messagingToken = await FirebaseMessaging.instance.getToken() ?? '';
      if (Platform.isIOS) {
        Environment.instance.apnsToken = await FirebaseMessaging.instance.getAPNSToken();
      }
      Environment.debug("messagingToken is '${Environment.instance.messagingToken}'");
      await Environment.instance.statusProvider.storeStatus();

      //FirebaseMessaging.instance.getInitialMessage();
      FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) {
        Environment.debug("messagingtoken has been refreshed: '$fcmToken'");
        Environment.instance.messagingToken = fcmToken;
        Environment.instance.statusProvider.storeStatus();
      }).onError((err) {
        // Error getting token
        _retryToken();
      });

      Environment.debug("listening to FCM messages");
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        Environment.debug("FCM: received a remote message");
        Environment.instance.notificationProvider.handleMessage(message);
      });

      Environment.debug("listening to FCM background messages");
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    } else {
      Environment.debug("not android or ios");
    }
  }

  static Future _retryToken() async {
    return Future.delayed(const Duration(milliseconds: 60 * 1000), () async {
      Environment.instance.messagingToken = await FirebaseMessaging.instance.getToken() ?? '';
      Environment.debug("messagingToken retrieved: '${Environment.instance.messagingToken}'");
      if (Environment.instance.messagingToken == '') {
        return _retryToken();
      } else {
        Environment.instance.statusProvider.storeStatus();
      }
    });
  }
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  Environment.debug("FCM: received a remote background message");
  //Environment.instance.notificationProvider.handleMessage(message);
}
