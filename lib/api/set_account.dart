import 'package:evf/environment.dart';
import 'package:evf/models/account_data.dart';

import 'interface.dart';

Future<bool> setAccount(AccountData data) async {
  try {
    Environment.debug("calling setAccount");
    final api = Interface.create(path: '/device/account', data: {'language': data.language});
    var content = await api.post();
    if (content.containsKey('status') && content['status'] == 'ok') {
      return true;
    }
    Environment.debug("setAccount returned content is $content");
  } on NetworkError {
    Environment.debug("setAccount fails due to exception");
  }
  Environment.debug("end of setAccount, error situation");
  return false;
}
