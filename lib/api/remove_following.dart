import 'package:evf/environment.dart';

import 'interface.dart';

Future<bool> removeFollowing(String id) async {
  try {
    Environment.debug("calling removeFollowing for $id");
    final api = Interface.create(path: '/device/follow', data: {
      'follow': {
        'fencer': id,
        'preferences': ['unfollow']
      }
    });
    var content = await api.post();
    if (content.containsKey('status') && content['status'] == 'ok') {
      return true;
    }
    Environment.debug("removeFollowing returned content is $content");
  } on NetworkError {
    Environment.debug("removeFollowing fails");
  }
  return false;
}
