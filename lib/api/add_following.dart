import 'package:evf/environment.dart';
import 'package:evf/models/follower.dart';

import 'interface.dart';

Future<bool> addFollowing(String id) async {
  try {
    Environment.debug("calling addFollowing for $id");
    final api = Interface.create(path: '/device/follow', data: {
      'follow': {'fencer': id}
    });
    var content = await api.post();
    if (content.containsKey('status') && content['status'] == 'ok') {
      return true;
    }
    Environment.debug("addFollowing returned content is $content");
  } on NetworkError {
    Environment.debug("addFollowing fails due to exception");
  }
  Environment.debug("end of addFollowing, error situation");
  return false;
}

Future<bool> addFollowingObject(Follower follower) async {
  try {
    var data = {
      'follow': {
        'fencer': follower.fencer.id,
        'preferences': follower.toPreferences(),
      },
    };
    final api = Interface.create(path: '/device/follow', data: data);
    var content = await api.post();
    if (content.containsKey('status') && content['status'] == 'ok') {
      return true;
    }
    Environment.debug("addFollowing returned content is $content");
  } on NetworkError {
    Environment.debug("addFollowing fails due to exception");
  }
  return false;
}
