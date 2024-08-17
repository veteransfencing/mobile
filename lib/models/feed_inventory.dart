// The FeedInventory represents the data structure in our local cache. It consists of
// several blocks each encoding a list of feeds from a specific year. This interface
// allows us to load and save blocks and determine if a block was changed, forcing us
// to re-export it.
// On load, we just load all items from all blocks to create a huge list. If this
// becomes a problem, we can restrict the number of blocks that are loaded at any
// given time.

import 'package:evf/environment.dart';

import 'feed_item.dart';

class FeedBlock {
  DateTime start;
  DateTime end;
  int count;
  String path;
  List<FeedItem> items = [];
  bool wasChanged = false;

  FeedBlock.forItem(FeedItem item)
      : start = DateTime(item.mutated.year, 1, 1, 0, 0, 0),
        end = DateTime(item.mutated.year + 1, 1, 1, 0, 0, 0),
        count = 0,
        path = 'feed_${item.mutated.year}.json';

  FeedBlock.fromJson(Map<String, dynamic> json)
      : start = DateTime.parse(json['start'] as String),
        end = DateTime.parse(json['end'] as String),
        count = int.tryParse(json['count'] ?? '0') ?? 0,
        path = json['path'] as String;

  Map<String, String> toJson() =>
      {'start': start.toIso8601String(), 'end': end.toIso8601String(), 'count': count.toString(), 'path': path};

  bool feedFitsBlock(FeedItem item) {
    // we check the mutation date to put the item in a block
    return (item.mutated.isAfter(start) && item.mutated.isBefore(end)) || (item.mutated.isAtSameMomentAs(start));
  }

  void add(FeedItem item) {
    Environment.debug("adding feed item to block");
    for (final li in items) {
      if (li.id == item.id) {
        Environment.debug("item already found in block");
        return;
      }
    }
    count += 1;
    items.add(item);
    wasChanged = true;
    Environment.debug("item added to block, changed flag set");
  }

  List<dynamic> export() {
    List<dynamic> retval = [];
    for (final item in items) {
      retval.add(item.toJson());
    }
    wasChanged = false;
    return retval;
  }

  void load(List<dynamic> items) {
    count = 0;
    for (final json in items) {
      final item = FeedItem.fromJson(json as Map<String, dynamic>);
      add(item);
    }
    wasChanged = false;
  }
}

class FeedInventory {
  List<FeedBlock> blocks = [];

  FeedInventory();

  FeedInventory.fromJson(List<dynamic> json) {
    Environment.debug("loading inventory from json");
    blocks = [];
    for (Map<String, dynamic> content in json) {
      final block = FeedBlock.fromJson(content);
      Environment.debug("adding block to inventory list");
      blocks.add(block);
    }
  }

  List<dynamic> toJson() {
    List<dynamic> retval = [];
    for (final block in blocks) {
      retval.add(block.toJson());
    }
    return retval;
  }

  FeedBlock findBlockForFeed(FeedItem item) {
    for (final block in blocks) {
      if (block.feedFitsBlock(item)) {
        return block;
      }
    }

    // create a new block based on the year for this feed
    final block = FeedBlock.forItem(item);
    blocks.add(block);
    return block;
  }
}
