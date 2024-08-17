import 'dart:convert';
import 'dart:io';
import 'package:evf/api/get_status.dart';
import 'package:evf/api/register_device.dart';
import 'package:evf/environment.dart';
import 'package:evf/models/status.dart';
import 'package:flutter/material.dart';

class StatusProvider extends ChangeNotifier {
  Status? status;
  bool isLoading = false;
  DateTime wasLoaded = DateTime.now();

  Future<String> registerNewDevice() async {
    Environment.debug("registerDeviceAndConvert");
    var device = await registerDevice();
    Environment.debug("returning json-encoded device");
    await Environment.instance.set('deviceid', device.deviceId);
    return device.deviceId;
  }

  Future storeStatus() async {
    Environment.debug('storing new status values');
    await registerDeviceStatus(Environment.instance.messagingToken, Platform.localeName);
  }

  Future<Status> loadStatus() async {
    status ??= Status();
    if (!isLoading) {
      isLoading = true;
      try {
        Environment.debug("getting network status");
        status = await getStatus();
        Environment.debug("received status");
        Environment.debug("status is ${jsonEncode(status)}");
        Environment.instance.cache.setCache(
          'status.json',
          const Duration(hours: 23), // just shy of a day, to ensure we reload tomorrow
          jsonEncode(status!.toJson()),
        );
      } catch (e) {
        Environment.debug("Could not read back end status");
      }
      isLoading = false;
      wasLoaded = DateTime.now();
      notifyListeners();

      // see if we need to renew the other providers
      Environment.debug("listeners notified of new status, requesting other providers to reload");
      Environment.debug("lastRanking is ${status!.lastRanking}");
      Environment.instance.followerProvider.syncItems(status!.following);
      Environment.instance.feedProvider.loadItems();
    }
    // return the old value while we are not loading, or when we finished loading
    return Future.value(status);
  }
}
