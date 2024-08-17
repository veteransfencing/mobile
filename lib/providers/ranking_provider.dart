// RankingProvider can load items from disk or over the network

import 'dart:convert';
import 'package:evf/api/load_ranking.dart';
import 'package:evf/models/ranking.dart';
import 'package:evf/environment.dart';
import 'base_provider.dart';

class RankingProvider extends BaseProvider {
  bool _loadedFromCache = false;
  List<Ranking> _items;

  RankingProvider() : _items = [];

  List<Ranking> get list => _items;

  void _add(Ranking item) {
    final itemId = item.catWeapon();
    debug("ranking: adding item to list $itemId ${item.isLoading} ${item.stored}");
    if (_contains(item.weapon, item.category)) {
      debug("ranking: replacing old entry");
      _items = _items.map((e) => e.catWeapon() == itemId ? item : e).toList();
    } else {
      debug("ranking: adding entry to list, then sorting $itemId");
      _items.add(item);
      // sorting should be quick, list is not that large
      _items.sort((a, b) => a.catWeapon().compareTo(b.catWeapon()));
    }
  }

  bool _contains(String weapon, String category) {
    final catWeapon = "$category/$weapon";
    return _items.map((e) => e.catWeapon()).toList().contains(catWeapon);
  }

  Ranking? _find(String weapon, String category) {
    final catWeapon = "$category/$weapon";
    for (final r in _items) {
      if (r.catWeapon() == catWeapon) {
        return r;
      }
    }
    return null;
  }

  void add(Ranking item) {
    _add(item);
    debug("ranking: notifying listeners after adding ranking");
    notifyListeners();
  }

  void addList(List<Ranking> items) {
    for (final item in items) {
      _add(item);
    }
    debug("ranking: notifying listeners after adding ranking");
    notifyListeners();
  }

  // load the feed items from our cached storage, if we haven't loaded them yet
  Future loadItems(String weapon, String category, {bool doForce = false}) async {
    debug("ranking: loading ranking items");
    if (!_loadedFromCache) {
      debug("ranking: loading ranking items from cache first");
      await loadItemsFromCache();
      _loadedFromCache = true;
      debug("ranking: loaded ranking items from cache");
    }

    // see if we may need to load new items from the back-end
    // status is set immediately during environment initialization, so is never null at this stage
    final status = Environment.instance.statusProvider.status!;
    debug("ranking: status lastRanking ${status.lastRanking}");
    // if we have no date, we have no feeds. Just set a very old date as default
    final lastDate = status.lastRanking == '' ? DateTime(2000, 1, 1) : DateTime.parse(status.lastRanking);
    final ranking = _find(weapon, category);

    // if there is no ranking, or the mutation date is more recent and we are not currently loading,
    // force load from the network
    if (ranking == null || (!ranking.isLoading && ranking.stored.isBefore(lastDate))) {
      debug("ranking: setting doForce because last retrieved date is before last ranking update");
      // the server indicates there may be newer ranking data
      doForce = true;
    } else {
      debug("ranking: not loading a new ranking ${ranking.isLoading} ${ranking.stored} $lastDate");
    }
    // we're not going to check the ranking count, it is not given on a per weapon/category basis
    if (doForce) {
      debug("ranking: loading ranking items from network");
      await loadRankingItems(weapon, category);
    }
    debug("ranking: end of loadItems");
  }

  Future loadItemsFromCache() async {
    try {
      final doc = jsonDecode(await Environment.instance.cache.getCache("ranking.json")) as List<dynamic>;
      List<Ranking> retval = [];
      for (var content in doc) {
        retval.add(Ranking.fromJson(content as Map<String, dynamic>));
      }
      addList(retval);
    } catch (e) {
      // just skip loading the items from cache, the cache is probably empty
    }
  }

  Future loadRankingItems(String weapon, String category) async {
    try {
      debug("ranking: loading items over the network");
      var ranking = _find(weapon, category);

      // if there is no ranking yet, add a new entry and indicate we are loading it
      if (ranking == null) {
        debug("ranking: no entry yet, so storing a plaeholder");
        ranking = Ranking(DateTime(2000, 1, 1), DateTime(2000, 1, 1), category, weapon, []);
        ranking.isLoading = true;
        ranking.stored = DateTime(2000, 1, 1);
        _add(ranking);
      }

      // load the latest ranking
      final networkItems = await loadRanking(weapon: weapon, category: category);
      networkItems.stored = DateTime.now();

      // add this and notify our listeners
      debug(
          "ranking: adding network result ${networkItems.isLoading} ${networkItems.stored} ${networkItems.positions.length}");
      add(networkItems);
      debug("ranking: added network result and notified listeners, storing in cache");
      await Environment.instance.cache.setCache(
        'ranking.json',
        const Duration(days: 21),
        jsonEncode(_items),
      );
      debug("ranking: end of loadRankingItems");
    } catch (e) {
      debug("ranking: caught $e");
      // probably returned a 404 and empty response
    }
  }

  Ranking getRankingFor(String category, String weapon) {
    // get the network call going if we need it
    loadItems(weapon, category);

    // See if we already have a ranking
    // The call above should have added an empty ranking with the isLoading state set to true
    for (var ranking in _items) {
      if (ranking.category == category && ranking.weapon == weapon) {
        debug(
            "found a ranking ${ranking.category} ${ranking.weapon} loading:${ranking.isLoading} stored:${ranking.stored}");
        return ranking;
      }
    }
    // we should never get here...
    debug("returning empty ranking for $category $weapon");
    var retval = Ranking(DateTime(2000, 1, 1), DateTime(2000, 1, 1), category, weapon, []);
    retval.isLoading = true;
    retval.stored = DateTime(2000, 1, 1);
    return retval;
  }
}
