import 'dart:developer';
import 'package:evf/api/send_error.dart';
import 'package:evf/providers/account_provider.dart';
import 'package:evf/providers/calendar_provider.dart';
import 'package:evf/providers/follower_provider.dart';
import 'package:evf/providers/notification_provider.dart';
import 'package:evf/providers/ranking_provider.dart';
import 'package:evf/providers/result_provider.dart';
import 'package:evf/util/alert.dart';
import 'package:evf/util/fcm.dart';
import 'package:intl/intl.dart';
import 'package:restart_app/restart_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:evf/initialization.dart';
import 'package:evf/providers/status_provider.dart';
import 'package:evf/providers/feed_provider.dart';
import 'package:evf/cache/file_cache.dart';
import 'package:evf/models/flavor.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class Environment {
  static Environment? _instance;

  Flavor flavor;
  FileCache cache;

  String authToken;
  FeedProvider feedProvider;
  CalendarProvider calendarProvider;
  RankingProvider rankingProvider;
  StatusProvider statusProvider;
  FollowerProvider followerProvider;
  ResultProvider resultsProvider;
  AccountProvider accountProvider;
  NotificationProvider notificationProvider;
  AppLocalizations? localizations;
  String messagingToken;
  String? apnsToken;

  Environment({required this.flavor})
      : cache = FileCache(),
        authToken = '',
        feedProvider = FeedProvider(),
        calendarProvider = CalendarProvider(),
        rankingProvider = RankingProvider(),
        statusProvider = StatusProvider(),
        followerProvider = FollowerProvider(),
        resultsProvider = ResultProvider(),
        accountProvider = AccountProvider(),
        notificationProvider = NotificationProvider(),
        messagingToken = '' {
    Environment._instance = this;
    debug("creating new navigator keys");
  }

  static void debug(String txt) {
    log(txt);
  }

  static Future<AppLocalizations> getI10N() async {
    try {
      return lookupAppLocalizations(Locale(Intl.getCurrentLocale()));
    } catch (e) {
      // locale not found, fall back to English
    }
    return lookupAppLocalizations(const Locale('en'));
  }

  static void error(String txt) async {
    sendError(txt);
    final msg = (await getI10N()).errorInternalError;
    alert(msg);
  }

  Future restart() async {
    await initialization();
    Restart.restartApp();
  }

  // convenience methods, only callable after initialization
  static Environment get instance => Environment._instance!;

  // implementation to persist simple local values
  SharedPreferences? _prefs;

  Future<String> preference(String key) async {
    return _prefs!.getString(key) ?? '';
  }

  Future<int> preferenceInt(String key) async {
    return _prefs!.getInt(key) ?? 0;
  }

  Future set(String key, String value) async {
    await _prefs!.setString(key, value);
  }

  Future setInt(String key, int value) async {
    await _prefs!.setInt(key, value);
  }

  Future remove(String key) async {
    await _prefs!.remove(key);
  }

  Future initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    debug("Initializing environment");
    _prefs = await SharedPreferences.getInstance();
    // Load the device ID, if any
    debug("registering device");
    var deviceId = await preference('deviceid');
    if (deviceId == '') {
      deviceId = await statusProvider.registerNewDevice();
    } else {
      debug("found existing device id $deviceId");
    }
    debug("setting authToken to $deviceId");
    authToken = deviceId;
    debug("calling initialize on cache");
    // cache requires preferences to be initialized
    await cache.initialize();

    await FCM.initialise();
    debug("end of environment initialization");
  }

  Future postInitialize() async {
    debug("running postinitialize, initialising FCM");
    await FCM.postInitialise();
    debug("end of post initialise");
  }
}
