import 'ranking_position.dart';

class Ranking {
  DateTime date;
  DateTime updated;
  DateTime stored; // local field
  String category;
  String weapon;
  List<RankingPosition> positions;
  bool isLoading;

  Ranking(this.date, this.updated, this.category, this.weapon, this.positions)
      : isLoading = false,
        stored = DateTime.now();

  Ranking.fromJson(Map<String, dynamic> doc)
      : date = DateTime.parse(doc['date'] as String),
        updated = DateTime.parse(doc['updated'] as String),
        stored = DateTime.now(),
        category = doc['category'] as String,
        weapon = doc['weapon'] as String,
        positions = [],
        isLoading = false {
    positions = (doc['positions'] as List<dynamic>)
        .map<RankingPosition>((d) => RankingPosition.fromJson(d as Map<String, dynamic>))
        .toList();
  }

  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'updated': updated.toIso8601String(),
        'stored': stored.toIso8601String(),
        'category': category,
        'weapon': weapon,
        'positions': positions,
      };

  String catWeapon() => "$category/$weapon";
}
