// The FeedList is the in-memory representation of all the items we are currently displaying
// New items are automatically sorted based on published date.
// Items with the same id are replaced (effectively: removed and re-inserted)
//
// The list maintains the last-mutation date. If an item is replaced and the new mutation date
// of that item is before the last mutation date, but that was the mutation date of the replaced
// item, this will fail. But that should not occur: mutation dates should only increase as new
// versions of a feed item are inserted.

import 'package:evf/environment.dart';

import './feed_item.dart';

class FeedList {
  List<FeedItem> _list = [];
  DateTime _lastMutation = DateTime(2000, 1, 1);

  FeedList();

  FeedList.fromJson(List<dynamic> json) {
    for (final doc in json) {
      add(FeedItem.fromJson(doc as Map<String, dynamic>));
    }
  }

  void add(FeedItem item) {
    Environment.debug("adding item to feedlist");
    if (item.mutated.isAfter(_lastMutation)) {
      Environment.debug("updating lastMutation to ${item.mutated}");
      _lastMutation = item.mutated;
    }
    if (_list.isEmpty) {
      _list.add(item);
    } else {
      // see if this item already exists in the list. In that case, just remove it.
      // The publication date probably did not change, but if it did, we need to
      // reorder the list anyway
      _list = _list.where((i) => i.id != item.id).toList();

      if (_list.last.published.isBefore(item.published)) {
        _list.add(item);
      } else if (_list.first.published.isAfter(item.published)) {
        _list.insert(0, item);
      } else {
        for (var i = 0; i < _list.length; i++) {
          if (_list[i].published.isAfter(item.published)) {
            _list.insert(i, item);
            break;
          }
        }
      }
    }
  }

  bool get isEmpty => _list.isEmpty;
  FeedItem get mostRecent => _list.isEmpty ? FeedItem() : _list.first;
  DateTime get mostRecentDate => _lastMutation;
  List<FeedItem> get list => _list;
}
