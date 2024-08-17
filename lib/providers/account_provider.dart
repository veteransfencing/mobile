// RankingProvider can load items from disk or over the network

import 'dart:convert';
import 'dart:io';

import 'package:evf/api/block_follower.dart';
import 'package:evf/api/get_account_data.dart';
import 'package:evf/api/set_preferences.dart';
import 'package:evf/environment.dart';
import 'package:evf/models/account_data.dart';

import 'base_provider.dart';

class AccountProvider extends BaseProvider {
  bool _loadedFromCache = false;
  bool _isLoading = false;
  DateTime? _lastChange;
  AccountData data;

  AccountProvider() : data = AccountData();

  Future loadItems() async {
    data.language = Platform.localeName;
    _loadItemsFromCache();

    if (!_isLoading) {
      debug("account: loading account data from server");
      await _loadNetworkData();
    }
    debug("account: end of loading $_isLoading");
  }

  Future _loadItemsFromCache() async {
    if (!_loadedFromCache) {
      try {
        final doc = jsonDecode(await Environment.instance.cache.getCache("account.json"));
        data = AccountData.fromJson(doc);
        Environment.debug("notifying listeners after updating account from cache");
        notifyListeners();
      } catch (e) {
        // just skip loading the items from cache, the cache is probably empty
      }
      _loadedFromCache = true;
    }
  }

  Future _storeItemsInCache() async {
    await Environment.instance.cache.setCache(
      'account.json',
      const Duration(days: 21),
      jsonEncode(data),
    );
  }

  Future _loadNetworkData() async {
    try {
      _isLoading = true;
      debug("account: loading data over the network");
      data = await getAccountData();
      debug("account: received network data");
      await _storeItemsInCache();
      debug("account: stored cache, notifying listeners");
      notifyListeners();
    } catch (e) {
      // probably returned a 404 and empty response
    }
    debug("account: setting isLoading to false");
    _isLoading = false;
  }

  void setData(AccountData accountData) {
    data = accountData;
    notifyListeners();
  }

  Future unfollow(String uuid) async {
    data.following = data.following.where((i) => i.fencer.id != uuid).toList();
    // update our 'quick list provider'
    await Environment.instance.followerProvider.unfollow(uuid);
    notifyListeners();
  }

  Future block(String uuid, bool doBlock) async {
    Environment.debug("blocking $doBlock user $uuid");
    if (data.followers.any((f) => f.user == uuid)) {
      data.followers = data.followers.map((f) {
        if (f.user == uuid) {
          f.blocked = doBlock;
        }
        return f;
      }).toList();
      // updated any dependent widget
      notifyListeners();
      Environment.debug("calling api");
      await blockFollower(uuid, doBlock);
      // if the call fails, so be it
      // no need to update the follower_provider, it only checks
      // fencers we follow
    } else {
      Environment.debug("user is not in followers list");
    }
  }

  void updatePreference(String type, String setting, bool doSet) {
    Environment.debug("updating $type with $setting $doSet");
    final dt = DateTime.now();
    _lastChange = dt;
    if (type == 'following') {
      final contains = data.preferences.following.contains(setting);
      Environment.debug("$setting $contains $doSet");
      if (doSet && !contains) {
        Environment.debug("adding $setting to following list");
        data.preferences.following.add(setting);
      } else if (!doSet && contains) {
        Environment.debug("removing $setting from following list");
        data.preferences.following = data.preferences.following.where((s) => s != setting).toList();
      }
    } else if (type == 'follower') {
      final contains = data.preferences.followers.contains(setting);
      if (doSet && !contains) {
        data.preferences.followers.add(setting);
      } else if (!doSet && contains) {
        data.preferences.followers = data.preferences.followers.where((s) => s != setting).toList();
      }
    }

    // make sure the widget updates now and shows the new check value
    notifyListeners();

    Future.delayed(const Duration(seconds: 1), () => _sendAndStorePreferences(dt));
  }

  Future _sendAndStorePreferences(DateTime dt) async {
    Environment.debug("sendAndStorePreferences");
    // only sync if the last update is at the same moment as the time passed
    // That means there has been no further update to the preferences since
    if (_lastChange != null && _lastChange!.isAtSameMomentAs(dt)) {
      try {
        Environment.debug("sending account preferences");
        final network = await setPreferences(data);
        if (network) {
          await _storeItemsInCache();
        }
      } catch (e) {
        // let it go for now...
      }
    } else {
      Environment.debug("skipping due to not same time");
    }
  }
}
