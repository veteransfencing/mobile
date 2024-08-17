// CalendarProvider can load items from disk or over the network

import 'dart:convert';
import 'package:evf/api/load_calendar.dart';
import 'package:evf/models/calendar.dart';
import 'package:flutter/foundation.dart';
import 'package:evf/environment.dart';

class CalendarProvider extends ChangeNotifier {
  bool _loadedFromCache = false;
  DateTime _lastMutation = DateTime(2000, 1, 1);
  List<Calendar> _items;

  CalendarProvider() : _items = [];

  List<Calendar> get list => _items;

  void _add(Calendar item, bool doSort) {
    if (_items.map((e) => e.id).toList().contains(item.id)) {
      _items = _items.map((e) => e.id == item.id ? item : e).toList();
      // we may have to resort due to a changed date
      if (doSort) {
        _items.sort((a, b) => a.startDate.compareTo(b.startDate));
      }
    } else {
      if (_items.isEmpty) {
        _items.add(item);
      } else if (_items.first.startDate.isAfter(item.startDate)) {
        _items.insert(0, item);
      } else if (_items.last.startDate.isBefore(item.startDate)) {
        _items.add(item);
      } else {
        _items.add(item);
        // sorting should be quick, as most of the list is already sorted
        if (doSort) {
          _items.sort((a, b) => a.startDate.compareTo(b.startDate));
        }
      }
    }
    if (item.mutated.isBefore(_lastMutation)) {
      _lastMutation = item.mutated;
    }
  }

  void add(Calendar item) {
    _add(item, true);
    notifyListeners();
  }

  void addList(List<Calendar> items) {
    for (final item in items) {
      _add(item, false);
    }
    // sort to be safe
    _items.sort((a, b) => a.startDate.compareTo(b.startDate));
    notifyListeners();
  }

  // load the feed items from our cached storage, if we haven't loaded them yet
  Future loadItems({bool doForce = false}) async {
    Environment.debug("loading calendar items");
    if (!_loadedFromCache) {
      Environment.debug("loading items from cache first");
      await loadItemsFromCache();
      _loadedFromCache = true;
    }

    // see if we may need to load new items from the back-end
    // status is set immediately during environment initialization, so is never null at this stage
    final status = Environment.instance.statusProvider.status!;

    // if we have no date, we have no feeds. Just set a very old date as default
    final lastDate = status.lastCalendar == '' ? DateTime(2000, 1, 1) : DateTime.parse(status.lastCalendar);

    Environment.debug("testing ${_lastMutation.toIso8601String()} vs ${lastDate.toIso8601String()}");
    if (_lastMutation.isBefore(lastDate)) {
      Environment.debug("setting doForce because last mutation is before last date");
      // there are pending feed items on the server with a more recent mutation date
      doForce = true;
    }
    // we're not going to check the calendar count: if the mutation date has changed, we can reload all of the
    // data, which should not be too much
    if (doForce) {
      Environment.debug("loading calendar items from network");
      await loadCalendarItems();
    }
  }

  Future loadItemsFromCache() async {
    try {
      final doc = jsonDecode(await Environment.instance.cache.getCache("calendar.json")) as List<dynamic>;
      List<Calendar> retval = [];
      for (var content in doc) {
        retval.add(Calendar.fromJson(content as Map<String, dynamic>));
      }
      addList(retval);
    } catch (e) {
      // just skip loading the items from cache, the cache is probably empty
    }
  }

  Future loadCalendarItems() async {
    final originalMutation = _lastMutation;
    final networkItems = await loadCalendar(lastDate: _lastMutation);
    addList(networkItems);
    if (originalMutation.isBefore(_lastMutation)) {
      await Environment.instance.cache.setCache(
        'calendar.json',
        const Duration(days: 7),
        jsonEncode(_items),
      );
    }
  }
}
