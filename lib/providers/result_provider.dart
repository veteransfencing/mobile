// RankingProvider can load items from disk or over the network

import 'dart:convert';
import 'package:evf/api/load_events.dart';
import 'package:evf/api/load_results.dart';
import 'package:evf/models/competition.dart';
import 'package:evf/models/event.dart';
import 'package:evf/environment.dart';
import 'base_provider.dart';

class ResultProvider extends BaseProvider {
  bool _loadedFromCache = false;
  bool _isLoading = false;
  DateTime _lastMutated = DateTime(2000, 1, 1);
  List<Event> _items;

  ResultProvider() : _items = [];

  List<Event> get list => _items;

  void addList(List<Event> items) {
    // overwrite our current list
    _items = [];
    for (final item in items) {
      if (item.mutated.isAfter(_lastMutated)) {
        _lastMutated = item.mutated;
      }
      _items.add(item);
    }

    // sort the list on date (desc) and name
    _items.sort((a, b) {
      int cmp = a.opens.compareTo(b.opens);
      if (cmp != 0) return -1 * cmp;
      return a.name.compareTo(b.name);
    });
    notifyListeners();
  }

  Event findEvent(int eid) {
    for (final event in _items) {
      if (event.id == eid) {
        return event;
      }
    }
    return Event();
  }

  Competition findCompetition(Event event, int cid) {
    // should we map... depends on the size of the list perhaps
    for (final competition in event.competitions) {
      if (competition.id == cid) {
        return competition;
      }
    }
    return Competition();
  }

  // load the event items from our cached storage, if we haven't loaded them yet
  Future loadItems({bool doForce = false}) async {
    debug("events: loading event items");
    if (!_loadedFromCache) {
      debug("events: loading event items from cache first");
      await loadItemsFromCache();
      _loadedFromCache = true;
      debug("events: loaded event items from cache");
    }

    // see if we may need to load new items from the back-end
    // status is set immediately during environment initialization, so is never null at this stage
    final status = Environment.instance.statusProvider.status!;
    debug("events: status lastResult ${status.lastResult}");
    // if we have no date, we have no results. Just set a very old date as default
    final lastDate = status.lastResult == '' ? DateTime(2000, 1, 1) : DateTime.parse(status.lastResult);

    // if there is no ranking, or the mutation date is more recent and we are not currently loading,
    // force load from the network
    if (!_isLoading && _lastMutated.isBefore(lastDate)) {
      debug("events: setting doForce because last retrieved date is before last events update");
      // the server indicates there may be newer ranking data
      doForce = true;
    } else {
      debug("events: not loading a new event list $_isLoading $_lastMutated $lastDate");
    }
    // we're not going to check the ranking count, it is not given on a per weapon/category basis
    if (doForce) {
      debug("events: loading event items from network");
      await loadNetworkItems();
    }
    debug("events: end of loadItems");
  }

  Future loadItemsFromCache() async {
    try {
      final doc = jsonDecode(await Environment.instance.cache.getCache("events.json")) as List<dynamic>;
      List<Event> retval = [];
      for (var content in doc) {
        retval.add(Event.fromJson(content as Map<String, dynamic>));
      }
      addList(retval);
    } catch (e) {
      // just skip loading the items from cache, the cache is probably empty
    }
  }

  Future loadNetworkItems() async {
    try {
      _isLoading = true;

      // load the latest list of events
      final networkItems = await loadEvents();

      // add this and notify our listeners
      debug("events: adding network result ${networkItems.length}");
      addList(networkItems);
      debug("events: added network result and notified listeners, storing in cache");
      await Environment.instance.cache.setCache(
        'events.json',
        const Duration(days: 21),
        jsonEncode(_items),
      );
      debug("events: end of loadNetworkItems");
    } catch (e) {
      debug("events: caught $e");
      // probably returned a 404 and empty response
    }
  }

  Future<Competition> loadCompetition(Competition competition) async {
    final content = await Environment.instance.cache
        .getCacheOrLoad("competition_${competition.id}.json", const Duration(days: 21), () async {
      return await loadResultsRaw(competition.id);
    });
    try {
      final doc = jsonDecode(content);
      notifyListeners();
      return Competition.fromJson(doc);
    } catch (e) {
      debug('events: caught exception decoding content for competition $e');
    }
    notifyListeners();
    return Competition();
  }
}
