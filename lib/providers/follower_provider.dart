import 'dart:convert';

import 'package:evf/api/add_following.dart' as api;
import 'package:evf/api/remove_following.dart' as api2;
import 'package:evf/environment.dart';
import 'package:evf/models/follower.dart';
import 'package:flutter/material.dart';

class FollowerProvider extends ChangeNotifier {
  Map<String, Follower> following = {};

  bool isLoading = false;
  DateTime wasLoaded = DateTime.now();
  bool _loadedFromCache = false;

  // load definitive data from the back-end
  // This is only required if we want to interface with the settings for each
  // follower/following
  Future load() async {
    if (!_loadedFromCache) {
      Environment.debug("loading items from cache first");
      await loadItemsFromCache();
    }
  }

  Future unfollow(String uuid) async {
    if (following.containsKey(uuid)) {
      return await removeFollowing(uuid);
    }
  }

  // toggle us following a fencer uuid
  Future<bool> toggleFollowing(String uuid) async {
    if (following.containsKey(uuid)) {
      return await removeFollowing(uuid);
    } else {
      return await addFollowing(uuid);
    }
  }

  // add us following a fencer uuid
  Future<bool> addFollowing(String uuid) async {
    final network = await api.addFollowing(uuid);
    if (network) {
      final follower = Follower(uuid);
      follower.synced = true;
      following[uuid] = follower;
      await _storeItemsInCache();
      notifyListeners();
    }
    return network;
  }

  Future<bool> removeFollowing(String uuid) async {
    if (following.containsKey(uuid) && following[uuid]!.synced) {
      final network = await api2.removeFollowing(uuid);
      if (network) {
        following.remove(uuid);
        await _storeItemsInCache();
        notifyListeners();
      }
      return network;
    }
    return true;
  }

  void syncItems(List<String> following) async {
    // this is called when the status was updated. We need to synchronize our database of
    // fencers we are following with the list of uuids in the status
    for (var uuid in following) {
      if (!this.following.containsKey(uuid)) {
        final follower = Follower(uuid);
        follower.synced = true;
        this.following[uuid] = follower;
      }
    }
    for (var key in this.following.keys) {
      if (!following.contains(key)) {
        this.following.remove(key);
      }
    }

    // the status update does not give us a list of who is following us

    await _storeItemsInCache();
    notifyListeners();
  }

  Future loadItemsFromCache() async {
    try {
      // list of fencers we follow, may or may not have a device user
      final doc2 = jsonDecode(await Environment.instance.cache.getCache("following.json")) as List<dynamic>;
      for (var content in doc2) {
        var follower = Follower.fromJson(content as Map<String, dynamic>);
        following[follower.fencer.id] = follower;
      }
      _loadedFromCache = true;
      notifyListeners();
    } catch (e) {
      // just skip loading the items from cache, the cache is probably empty
    }
  }

  Future _storeItemsInCache() async {
    await Environment.instance.cache.setCache("following.json", const Duration(days: 7), jsonEncode(following));
  }

  void updateFollowing(Follower follower) {
    Environment.debug("processing update to follower");
    final dt = DateTime.now();
    follower.lastUpdate = dt;
    follower.synced = false;
    following[follower.fencer.id] = follower;
    // make sure the widget updates now and shows the new check value
    notifyListeners();

    Future.delayed(const Duration(seconds: 1), () => _sendAndStoreItems(dt, follower.fencer.id));
  }

  Future _sendAndStoreItems(DateTime dt, String uuid) async {
    Environment.debug("sendAndStoreItems");
    // only sync if the last update is at the same moment as the time passed
    // That means there has been no further update to this follower since
    if (following.containsKey(uuid) &&
        following[uuid]!.lastUpdate != null &&
        following[uuid]!.lastUpdate!.isAtSameMomentAs(dt)) {
      try {
        Environment.debug("sending FollowingObject with preferences");
        final network = await api.addFollowingObject(following[uuid]!);
        if (network) {
          following[uuid]!.synced = true;
          following[uuid]!.lastUpdate = null;
          await _storeItemsInCache();
          notifyListeners();
        }
      } catch (e) {
        // let it go for now...
      }
    } else {
      Environment.debug("skipping due to not same time");
    }
  }
}
