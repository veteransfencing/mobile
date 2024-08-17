import 'dart:convert';
import 'dart:io';
import 'package:evf/environment.dart';
import 'package:path_provider/path_provider.dart';
import 'package:evf/util/random_string.dart';
import 'cache_data.dart';
import 'cache_line.dart';

typedef CacheMiss = Future<String> Function();

class FileCache {
  CacheData? _cache;

  Future initialize() async {
    Environment.debug("initializing cache");
    var content = await Environment.instance.preference('cache');
    try {
      Environment.debug("application cache is $content");
      _cache = CacheData.fromJson(jsonDecode(content));
    } catch (e) {
      Environment.debug("caught error $e on reading cache, creating empty cache");
      _cache = CacheData.fromJson({});
    }
  }

  Future<String> _getDirectory() async {
    final directory = await getApplicationCacheDirectory();
    return directory.path;
  }

  Future<String> _loadFile(String path) async {
    try {
      Environment.debug("loading file $path");
      final directory = await _getDirectory();
      Environment.debug("loading from $directory/$path");
      var file = File('$directory/$path');
      Environment.debug("reading as string");
      return await file.readAsString();
    } catch (e) {
      // caught an error, prevent the fail by providing an empty string
      Environment.debug("caught exception ${e.toString()}");
    }
    Environment.debug("returning empty string as fail-over");
    return '';
  }

  Future _storeFile(String destination, String content) async {
    try {
      final directory = await _getDirectory();

      var file = File('$directory/$destination');
      file.writeAsString(content);
    } catch (e) {
      // caught an error, don't store the new cache data
      Environment.debug("caught error writing file");
    }
  }

  Future<String> getCache(String path) async {
    if (_cache != null && _cache!.containsKey(path)) {
      var localpath = _cache!.timestamps[path]!.path;
      return await _loadFile("$localpath.json");
    }
    return Future.value('');
  }

  CacheLine getCacheData(String path) {
    if (_cache != null && _cache!.containsKey(path)) {
      return _cache!.timestamps[path]!;
    }
    return CacheLine(path: '', policy: DateTime.now());
  }

  Future setCache(String path, Duration policy, String content) async {
    if (_cache != null) {
      final directory = await _getDirectory();
      var destination = _getRandomDestination(directory);
      if (_cache!.containsKey(path)) {
        destination = _cache!.timestamps[path]!.path;
      }
      Environment.debug("storing cached file at $destination");
      await _storeFile("$destination.json", content);

      Environment.debug("cached file stored");
      await _clearCacheForKey(path);
      _cache!.setCached(key: path, path: destination, policy: policy);

      Environment.debug("updating cache");
      await _updateCache();
      Environment.debug("cache updated");
    }
  }

  Future<String> getCacheOrLoad(String path, Duration policy, CacheMiss? callback) async {
    await clearCacheIfOlder(path, DateTime(2000, 1, 1));
    if (_cache != null && _cache!.containsKey(path)) {
      var localpath = _cache!.timestamps[path]!.path;
      return await _loadFile("$localpath.json");
    }
    var content = '';
    Environment.debug("cache miss on getCacheOrLoad for $path");
    if (callback != null) {
      Environment.debug("awaiting cache callback");
      content = await callback();
      Environment.debug("content is $content");
      Environment.debug("storing content in cache");
      await setCache(path, policy, content);
    }
    return content;
  }

  Future clearCacheIfOlder(String path, DateTime ts) async {
    if (_cache != null && _cache!.timestamps.containsKey(path)) {
      var currentData = _cache!.timestamps[path];
      if (currentData!.date.isBefore(ts) || currentData.policy.isBefore(DateTime.now())) {
        await _clearCacheForKey(path);
        await _updateCache();
      }
    }
  }

  Future clearPolicy() async {
    final now = DateTime.now();
    bool anyRemoved = false;
    for (final key in _cache!.timestamps.keys) {
      if (_cache!.timestamps[key]!.policy.isBefore(now)) {
        await _clearCacheForKey(key);
        anyRemoved = true;
      }
    }
    if (anyRemoved) {
      await _updateCache();
    }
  }

  Future _clearCacheForKey(String path) async {
    if (_cache != null && _cache!.timestamps.containsKey(path)) {
      var destination = _cache!.timestamps[path]!.path;
      if (await File(destination).exists()) {
        try {
          await File(destination).delete();
        } catch (e) {
          // pass on remove errors
        }
      }
      _cache!.timestamps.remove(path);
    }
  }

  Future _updateCache() async {
    final doc = jsonEncode(_cache!.timestamps);
    Environment.debug("updating cache to $doc");
    return await Environment.instance.set('cache', doc);
  }

  String _getRandomDestination(String directory) {
    var filename = getRandomString(24);
    var destination = '$directory/$filename.json';
    while (File(destination).existsSync()) {
      filename = getRandomString(24);
      destination = '$directory/$filename.json';
    }
    return filename;
  }
}
