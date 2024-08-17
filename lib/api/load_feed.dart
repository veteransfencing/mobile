// Load all available feed items from the back-end.
// At this point, we assume that this list is not very huge, so we can just load everything at
// once. If feed lists become too large at some point, we may need to apply some pagination
// to load it in parts

import 'package:evf/models/feed_list.dart';
import 'package:evf/environment.dart';
import 'interface.dart';

Future<FeedList> loadFeed({DateTime? lastDate}) async {
  try {
    Environment.debug("calling loadFeed");
    final api = Interface.create(path: '/device/feed');
    if (lastDate != null) {
      api.data['last'] = lastDate.toIso8601String();
    }
    var content = await api.get();
    return FeedList.fromJson(content as List<dynamic>);
  } catch (e) {
    Environment.debug("caught $e while loading feed");
  }
  return FeedList();
}
