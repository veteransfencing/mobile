import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'interface.dart';
import 'package:evf/models/device.dart';
import 'package:evf/environment.dart';

Future<Device> registerDevice({int tries = 0}) async {
  try {
    Environment.debug("calling registerDevice($tries)");
    final data = await getDeviceInfo();
    final api = Interface.create(path: '/device/register', data: data);
    var content = await api.post();
    if (content.containsKey('id')) {
      Environment.debug("registerDevice succeeds ${content.toString()}");
      return Device.fromJson(content);
    }
    Environment.error("RegisterDevice returns status 200 but not an id");
  } on NetworkError {
    if (tries < 3) {
      Environment.debug("retrying registerDevice");
      return await Future.delayed(
        const Duration(microseconds: 500),
        () => registerDevice(tries: tries + 1),
      );
    }
    Environment.error("RegisterDevice fails after retries, device id could not be set");
  }
  return Device(id: '');
}

Future registerDeviceStatus(String token, String locale, {int tries = 0}) async {
  try {
    final api = Interface.create(path: '/device/register/status', data: {'token': token, 'locale': locale});
    await api.post();
    Environment.debug("device status updated");
  } on NetworkError {
    if (tries < 3) {
      Environment.debug("retrying registerDeviceStatus");
      return await Future.delayed(
        const Duration(microseconds: 2000),
        () => registerDeviceStatus(token, locale, tries: tries + 1),
      );
    } else {
      Environment.debug("failed to update device status");
    }
  }
}

Future<Map<String, String>> getDeviceInfo() async {
  final deviceInfo = DeviceInfoPlugin();
  Map<String, String> retval = {
    'language': Platform.localeName,
    'platform': Platform.operatingSystem,
    'version': Platform.operatingSystemVersion,
  };
  if (kIsWeb) {
    final browserInfo = await deviceInfo.webBrowserInfo;
    retval['manufacturer'] = browserInfo.browserName.toString();
    retval['language'] = browserInfo.language ?? 'unknown';
    retval['vendor'] = browserInfo.vendor ?? 'unknown';
    retval['osVersion'] = browserInfo.platform ?? (browserInfo.appVersion ?? 'unknown');
    retval['build'] = browserInfo.userAgent ?? 'unknown';
  } else {
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      retval['manufacturer'] = androidInfo.manufacturer;
      retval['model'] = androidInfo.model;
      retval['osVersion'] = androidInfo.version.toString();
      retval['uid'] = androidInfo.serialNumber;
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      retval['model'] = iosInfo.model;
      retval['osVersion'] = iosInfo.systemVersion;
      retval['uid'] = iosInfo.identifierForVendor ?? 'unknown';
    } else if (Platform.isLinux) {
      final linuxInfo = await deviceInfo.linuxInfo;
      retval['manufacturer'] = linuxInfo.name;
      retval['model'] = linuxInfo.id;
      retval['osVersion'] = linuxInfo.version ?? 'unknown';
      retval['uid'] = linuxInfo.machineId ?? 'unknown';
    } else if (Platform.isWindows) {
      final windowsInfo = await deviceInfo.windowsInfo;
      retval['model'] = windowsInfo.productName;
      retval['osVersion'] = windowsInfo.displayVersion;
      retval['build'] = windowsInfo.buildNumber.toString();
      retval['uid'] = windowsInfo.deviceId;
    } else if (Platform.isMacOS) {
      final macosInfo = await deviceInfo.macOsInfo;
      retval['model'] = macosInfo.model;
      retval['osVersion'] = "${macosInfo.majorVersion}.${macosInfo.minorVersion}";
      retval['uid'] = macosInfo.systemGUID ?? 'unknown';
    } else {
      final otherInfo = await deviceInfo.deviceInfo;
      retval['data'] = otherInfo.toString();
    }
  }
  return retval;
}
