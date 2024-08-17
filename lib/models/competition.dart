import 'package:evf/environment.dart';

import 'competition_result.dart';

class Competition {
  int id;
  DateTime starts;
  String category;
  String weapon;
  List<CompetitionResult> results;

  Competition()
      : id = 0,
        starts = DateTime.now(),
        category = '1',
        weapon = 'MF',
        results = [];

  Competition.fromJson(Map<String, dynamic> doc)
      : id = doc['id'] as int,
        starts = DateTime.parse(doc['starts'] as String),
        category = doc['category'] as String,
        weapon = doc['weapon'] as String,
        results = [] {
    if (doc.containsKey('results')) {
      try {
        for (var el in doc['results']) {
          results.add(CompetitionResult.fromJson(el as Map<String, dynamic>));
        }
      } catch (e) {
        Environment.debug('caught error converting results');
      }
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'starts': starts.toIso8601String(),
        'category': category,
        'weapon': weapon,
        'results': results,
      };
}
