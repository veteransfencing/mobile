// Load a specific ranking from the back-end.
// At this point, we assume that this list is not very huge, so we can just load everything at
// once.

import 'package:evf/models/ranking.dart';
import 'package:evf/environment.dart';
import 'interface.dart';

Future<Ranking> loadRanking({required String weapon, required String category, DateTime? lastDate}) async {
  try {
    Environment.debug("calling loadRanking");
    final api = Interface.create(path: "/device/ranking/$weapon/$category");
    if (lastDate != null) {
      api.data['last'] = lastDate.toIso8601String();
    }
    var content = await api.get();
    final retval = Ranking.fromJson(content);
    return retval;
  } catch (e) {
    Environment.debug("caught exception on loading ranking $e");
  }
  return Ranking(DateTime(2000, 1, 1), DateTime(2000, 1, 1), weapon, category, []);
}
