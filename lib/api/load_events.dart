// Load the list of events and competitions
// At this point, we assume that this list is not very huge, so we can just load everything at
// once.

import 'package:evf/environment.dart';
import 'package:evf/models/event.dart';
import 'interface.dart';

Future<List<Event>> loadEvents() async {
  try {
    final api = Interface.create(path: "/device/events");
    var content = await api.get();
    final List<Event> retval = [];
    for (final event in (content as List<dynamic>)) {
      retval.add(Event.fromJson(event));
    }
    return retval;
  } catch (e) {
    Environment.debug("caught exception on loading events $e");
  }
  return [];
}
