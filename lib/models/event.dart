import 'package:evf/environment.dart';

import 'competition.dart';

class Event {
  int id;
  String name;
  int year;
  DateTime opens;
  DateTime closes;
  DateTime mutated;
  String location;
  String country;
  String website;
  List<Competition> competitions;

  Event()
      : id = 0,
        name = '',
        year = 2000,
        opens = DateTime(2000, 1, 1),
        closes = DateTime(2000, 1, 1),
        mutated = DateTime(2000, 1, 1),
        location = '',
        country = '',
        website = '',
        competitions = [];

  Event.fromJson(Map<String, dynamic> doc)
      : id = doc['id'] as int,
        name = doc['name'] as String,
        year = doc['year'] as int,
        opens = DateTime.parse(doc['opens'] as String),
        closes = DateTime.parse(doc['closes'] as String),
        mutated = DateTime.parse(doc['mutated'] as String),
        location = doc['location'] as String,
        country = doc['country'] as String,
        website = (doc['website'] ?? ''),
        competitions = [] {
    try {
      for (var c in (doc['competitions'] as List<dynamic>)) {
        competitions.add(Competition.fromJson(c as Map<String, dynamic>));
      }
    } catch (e) {
      Environment.debug('caught error converting competitions');
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'year': year,
        'opens': opens.toIso8601String(),
        'closes': closes.toIso8601String(),
        'mutated': mutated.toIso8601String(),
        'location': location,
        'country': country,
        'website': website,
        'competitions': competitions,
      };
}
