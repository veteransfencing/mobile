import 'package:evf/environment.dart';
import 'package:evf/models/fencer.dart';

class Follower {
  Fencer fencer;
  String user = '';
  bool handout = true;
  bool checkin = true;
  bool checkout = true;
  bool ranking = true;
  bool result = true;
  bool register = true;
  bool blocked = false;
  bool unfollow = false; // local setting
  bool synced = false; // local setting

  // locally used fields
  DateTime? lastUpdate;

  Follower(String uuid) : fencer = Fencer(uuid);
  Follower.device(String uuid)
      : fencer = Fencer(''),
        user = uuid;

  Follower.fromJson(Map<String, dynamic> doc)
      : fencer = Fencer.fromJson(doc['fencer'] ?? {}),
        user = doc['user'] ?? '' {
    try {
      final preferences = doc['preferences'] as List<dynamic>;
      handout = false;
      checkin = false;
      checkout = false;
      ranking = false;
      result = false;
      register = false;
      blocked = false;

      for (String p in preferences) {
        switch (p) {
          case 'handout':
            handout = true;
            break;
          case 'checkin':
            checkin = true;
            break;
          case 'checkout':
            checkout = true;
            break;
          case 'ranking':
            ranking = true;
            break;
          case 'result':
            result = true;
            break;
          case 'register':
            register = true;
            break;
          case 'block':
            blocked = true;
            break;
        }
      }
    } catch (e) {
      // probably a non-existing or empty list
      Environment.debug("caught $e on preference conversion");
    }
  }

  List<String> toPreferences() {
    List<String> preferences = [];
    if (handout) preferences.add('handout');
    if (checkin) preferences.add('checkin');
    if (checkout) preferences.add('checkout');
    if (ranking) preferences.add('ranking');
    if (result) preferences.add('result');
    if (register) preferences.add('register');
    if (blocked) preferences.add('block');
    if (synced) preferences.add('synced');
    return preferences;
  }

  Map<String, dynamic> toJson() {
    return {
      'fencer': fencer,
      'user': user,
      'preferences': toPreferences(),
    };
  }
}
