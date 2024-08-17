import 'fencer.dart';
import 'rank_result.dart';

class RankDetails {
  final Fencer fencer;
  final String weapon;
  final String category;
  final DateTime date;
  final int position;
  final double points;
  final List<RankResult> results;

  RankDetails()
      : fencer = Fencer(''),
        weapon = '',
        category = '',
        date = DateTime.now(),
        position = 0,
        points = 0.0,
        results = [];

  RankDetails.fromJson(Map<String, dynamic> doc)
      : fencer = Fencer.fromJson(doc['fencer']),
        weapon = doc['weapon'] as String,
        category = doc['category'] as String,
        date = DateTime.parse(doc['date'] as String),
        position = doc['position'] as int,
        points = doc['points'] as double,
        results = [] {
    for (var el in doc['results']) {
      results.add(RankResult.fromJson(el as Map<String, dynamic>));
    }
  }

  Map<String, dynamic> toJson() => {
        "fencer": fencer.toJson(),
        "weapon": weapon,
        "category": category,
        "date": date.toIso8601String(),
        "position": position,
        "points": points,
        "results": results
      };
}
