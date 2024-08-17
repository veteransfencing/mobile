// FeedProvider can load new feed items from disk and over the network, trying to keep
// both stores synchronized. FeedProvider exports the item list for display purposes.
// Whenever a new item is added to the list, all subscribers are notified of the change

import 'dart:convert';
import 'package:evf/api/load_feed.dart';
import 'package:evf/models/feed_inventory.dart';
import 'package:flutter/foundation.dart';
import 'package:evf/models/feed_item.dart';
import 'package:evf/models/feed_list.dart';
import 'package:evf/environment.dart';

class FeedProvider extends ChangeNotifier {
  bool _loadedFromCache = false;
  final FeedList _items = FeedList();
  FeedInventory inventory;

  FeedProvider() : inventory = FeedInventory();

  FeedList get list => _items;

  void add(List<FeedItem> items) {
    for (final item in items) {
      _items.add(item);
    }
    notifyListeners();
  }

  // load the feed items from our cached storage, if we haven't loaded them yet
  Future loadItems({bool doForce = false}) async {
    Environment.debug("loading feed items $_loadedFromCache $doForce");
    if (!_loadedFromCache) {
      await loadItemInventory();
      await loadItemBlocks();
      _loadedFromCache = true;
    }

    // see if we may need to load new items from the back-end
    // status is set immediately during environment initialization, so is never null at this stage
    final status = Environment.instance.statusProvider.status!;

    // if we have no date, we have no feeds. Just set a very old date as default
    final lastDate = status.lastFeed == '' ? DateTime(2000, 1, 1) : DateTime.parse(status.lastFeed);

    Environment.debug("most recent date is ${_items.mostRecentDate} vs $lastDate");
    if (_items.mostRecentDate.isBefore(lastDate)) {
      // there are pending feed items on the server with a more recent mutation date
      doForce = true;
    }
    // we're not going to check the feed count, because we only get a restricted number of feeds from
    // the back-end (last 2 years) and we might have more feeds stored locally.

    if (doForce) {
      Environment.debug("loading newer feed items from network");
      await loadFeedItems();
    }
  }

  Future loadItemInventory() async {
    try {
      Environment.debug("loading feeds from cache");
      final doc = await Environment.instance.cache.getCache("feeds.json");
      inventory = FeedInventory.fromJson(jsonDecode(doc) as List<dynamic>);
    } catch (e) {
      Environment.debug("caught $e loading item inventory");
      // if there are problems, start with a clean feed
      inventory = FeedInventory();
    }
  }

  Future loadItemBlocks() async {
    Environment.debug("loading item blocks");
    for (final block in inventory.blocks) {
      try {
        Environment.debug("loading feed block from cache: ${block.path}");
        final doc = await Environment.instance.cache.getCache(block.path);
        block.load(jsonDecode(doc) as List<dynamic>);
        // add it to our display list
        add(block.items);
      } catch (e) {
        Environment.debug("caught $e converting item block");
        // if we failed to load the items, just skip the block
      }
    }
  }

  Future saveItemBlock(FeedBlock block) async {
    Environment.debug("saving feed block");
    final content = block.export();
    await Environment.instance.cache.setCache(
      block.path,
      const Duration(days: 7),
      jsonEncode(content),
    );
  }

  Future saveItemInventory() async {
    Environment.debug("saving feed inventory");
    final content = jsonEncode(inventory.toJson());
    await Environment.instance.cache.setCache(
      "feeds.json",
      const Duration(days: 7),
      content,
    );
  }

  Future loadFeedItems() async {
    Environment.debug("loading feed items over the network");
    final networkItems = await loadFeed(lastDate: _items.mostRecentDate);
    Environment.debug("adding network items to list");
    add(networkItems.list);

    // adjust the caching block setup
    for (final item in networkItems.list) {
      final block = inventory.findBlockForFeed(item);
      block.add(item);
    }

    Environment.debug("determining if there were any changes");
    var wasChanged = false;
    for (final block in inventory.blocks) {
      if (block.wasChanged) {
        Environment.debug("found changed block");
        wasChanged = true;
        await saveItemBlock(block);
      } else {
        Environment.debug("block was not changed");
      }
    }
    if (wasChanged) {
      await saveItemInventory();
    } else {
      Environment.debug("no changes detected in blocks");
    }
  }
}
