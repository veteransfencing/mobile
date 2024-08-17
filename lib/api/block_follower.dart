import 'package:evf/environment.dart';

import 'interface.dart';

Future<bool> blockFollower(String id, bool doBlock) async {
  try {
    Environment.debug("calling blockFollower for $id");
    final api = Interface.create(path: '/device/block', data: {
      'block': {'id': id, 'block': doBlock ? 'Y' : 'N'}
    });
    var content = await api.post();
    if (content.containsKey('status') && content['status'] == 'ok') {
      return true;
    }
    Environment.debug("blockFollower returned content is $content");
  } on NetworkError {
    Environment.debug("blockFollower fails due to exception");
  }
  Environment.debug("end of blockFollower, error situation");
  return false;
}
