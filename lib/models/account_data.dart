import 'package:evf/environment.dart';
import 'package:evf/models/account_preferences.dart';
import 'package:evf/models/fencer_private.dart';
import 'package:evf/models/follower.dart';

class AccountData {
  String id = '';
  String device = '';
  String email = '';
  String language = 'en_GB';
  DateTime verificationSent;
  bool isVerified = false;
  AccountPreferences preferences;
  FencerPrivate fencer;
  List<Follower> followers = [];
  List<Follower> following = [];

  AccountData()
      : verificationSent = DateTime(2000, 1, 1),
        preferences = AccountPreferences(),
        fencer = FencerPrivate();

  AccountData.fromJson(Map<String, dynamic> doc)
      : id = doc['id'] ?? '',
        device = doc['device'] ?? '',
        email = doc['email'] ?? '',
        language = doc['preferences']['language'] ?? 'en_GB',
        verificationSent = DateTime.parse(doc['verificationSent'] ?? '2000-01-01'),
        isVerified = doc['isVerified'] ?? false,
        preferences = AccountPreferences(),
        fencer = FencerPrivate() {
    Environment.debug("converting account fencer");
    if (doc['fencer'] != null) {
      fencer = FencerPrivate.fromJson(doc['fencer']);
    }

    Environment.debug("converting account preferences");
    preferences = AccountPreferences.fromJson(doc['preferences'] ?? {});

    Environment.debug("converting list of followers");
    followers = ((doc['followers'] ?? []) as List<dynamic>)
        .map<Follower>((d) => Follower.fromJson(d as Map<String, dynamic>))
        .toList();

    Environment.debug("converting list of following");
    following = ((doc['following'] ?? []) as List<dynamic>)
        .map<Follower>((d) => Follower.fromJson(d as Map<String, dynamic>))
        .toList();
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'device': device,
        'email': email,
        'language': language,
        'lastVerified': verificationSent.toIso8601String(),
        "isVerified": isVerified,
        "preferences": preferences.toJson(),
        "followers": followers,
        "following": following
      };
}
