// Send an error message back to the server for later investigation

import 'package:evf/environment.dart';

import 'interface.dart';

Future sendError(String message) async {
  try {
    final api = Interface.create(path: '/device/error', data: {
      'message': message,
      'deviceId': Environment.instance.authToken,
    });
    await api.postRaw();
  } catch (e) {
    // do not report on errors in this interface
  }
}
