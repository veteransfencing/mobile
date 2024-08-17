// Load the results of a specific competition

import 'package:evf/environment.dart';
import 'package:evf/models/competition.dart';
import 'interface.dart';

Future<Competition> loadResults(int competitionId) async {
  try {
    final api = Interface.create(path: "/device/results/$competitionId");
    var content = await api.get();
    return Competition.fromJson(content);
  } catch (e) {
    Environment.debug("caught exception loading competition results $e");
  }
  return Competition();
}

Future<String> loadResultsRaw(int competitionId) async {
  try {
    final api = Interface.create(path: "/device/results/$competitionId");
    return await api.getRaw();
  } catch (e) {
    Environment.debug("caught exception loading raw results $e");
  }
  return "{}";
}
