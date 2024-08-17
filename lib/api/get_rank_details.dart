// Load a fencers ranking details based on weapon and fencer uuid

import 'package:evf/models/rank_details.dart';
import 'package:evf/environment.dart';
import 'interface.dart';

Future<RankDetails> getRankDetails(String uuid, String weapon) async {
  try {
    Environment.debug("calling getRankDetails");
    final api = Interface.create(path: "/device/rankdetails/$weapon/$uuid");
    var content = await api.get();
    Environment.debug("converting rank-details from Json");
    var retval = RankDetails.fromJson(content);
    return retval;
  } catch (e) {
    Environment.debug("caught conversion error $e");
  }
  return RankDetails();
}
