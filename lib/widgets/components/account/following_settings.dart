import 'dart:convert';

import 'package:evf/environment.dart';
import 'package:evf/models/follower.dart';
import 'package:evf/widgets/components/account/labeled_checkbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FollowingSettings extends StatelessWidget {
  final Follower following;

  const FollowingSettings({super.key, required this.following});

  @override
  Widget build(BuildContext context) {
    Environment.debug("building settings for ${jsonEncode(following)}");
    return Padding(
        padding: const EdgeInsets.fromLTRB(20, 5, 20, 15),
        child: Column(children: [
          LabeledCheckbox(
            label: AppLocalizations.of(context)!.labelFollowResults,
            checked: _isChecked('results'),
            onCheck: (v) => _check('results', v),
          ),
          LabeledCheckbox(
            label: AppLocalizations.of(context)!.labelFollowRanking,
            checked: _isChecked('ranking'),
            onCheck: (v) => _check('ranking', v),
          ),
          LabeledCheckbox(
            label: AppLocalizations.of(context)!.labelFollowRegister,
            checked: _isChecked('register'),
            onCheck: (v) => _check('register', v),
          ),
          LabeledCheckbox(
            label: AppLocalizations.of(context)!.labelFollowEvent,
            checked: _isChecked('event'),
            onCheck: (v) => _check('event', v),
          ),
        ]));
  }

  bool _isChecked(String settings) {
    switch (settings) {
      case 'results':
        return following.result;
      case 'ranking':
        return following.ranking;
      case 'register':
        return following.register;
      case 'event':
        return following.handout || following.checkin || following.checkout;
    }
    return false;
  }

  void _check(String settings, bool value) {
    Environment.debug("marking check $value on $settings");
    switch (settings) {
      case 'results':
        following.result = !value;
        break;
      case 'ranking':
        following.ranking = !value;
        break;
      case 'register':
        following.register = !value;
        break;
      case 'event':
        following.handout = !value;
        following.checkin = !value;
        following.checkout = !value;
        break;
    }

    // this sets the new follower in the instance list
    Environment.instance.followerProvider.updateFollowing(following);
  }
}
