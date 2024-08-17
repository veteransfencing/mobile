import 'package:evf/environment.dart';
import 'package:evf/models/account_data.dart';

import 'interface.dart';

Future<bool> setPreferences(AccountData data) async {
  try {
    Environment.debug("calling setPreferences");
    final api = Interface.create(
        path: '/device/account/preferences',
        data: {'following': data.preferences.following, 'followers': data.preferences.followers});
    var content = await api.post();
    if (content.containsKey('status') && content['status'] == 'ok') {
      return true;
    }
    Environment.debug("setPreferences returned content is $content");
  } on NetworkError {
    Environment.debug("setPreferences fails due to exception");
  }
  Environment.debug("end of setPreferences, error situation");
  return false;
}
