// Load the initial status from the back-end
// If the current device id is not recognised, this will cause an unAuth error (403)
// which indicates we need to reregister. Apparently the device was removed from
// the backend.

import 'package:evf/models/account_data.dart';
import 'package:evf/environment.dart';
import 'interface.dart';

Future<AccountData> getAccountData({int tries = 0}) async {
  try {
    final api = Interface.create(path: '/device/account');
    var content = await api.get();
    Environment.debug("converting AccountData from api response");
    var retval = AccountData.fromJson(content);
    Environment.debug("returning converted data");
    return retval;
  } catch (e) {
    Environment.debug("caught conversion error $e");
  }
  return AccountData();
}
