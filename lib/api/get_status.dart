// Load the initial status from the back-end
// If the current device id is not recognised, this will cause an unAuth error (403)
// which indicates we need to reregister. Apparently the device was removed from
// the backend.

import 'package:evf/models/status.dart';
import 'package:evf/environment.dart';
import 'interface.dart';

Future<Status> getStatus({int tries = 0}) async {
  try {
    final api = Interface.create(path: '/device/status');
    var content = await api.get();
    Environment.debug("converting status response from Json");
    var retval = Status.fromJson(content);
    Environment.debug("status converted");
    return retval;
  } catch (e) {
    Environment.debug("caught conversion error $e");
  }
  return Status();
}
