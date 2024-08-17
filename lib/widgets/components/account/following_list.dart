import 'package:evf/environment.dart';
import 'package:evf/models/account_data.dart';
import 'package:evf/models/follower.dart';
import 'package:evf/styles.dart';
import 'package:evf/widgets/basic/fitted_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'following_component.dart';

class FollowingList extends StatelessWidget {
  final AccountData data;
  const FollowingList({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    Environment.debug("building following list based on ${data.following.length} entries");
    final List<Follower> values = data.following;
    List<Widget> children = values.map<Widget>((Follower f) => FollowingComponent(follower: f)).toList();
    children.insert(
        0,
        FittedText(
          span: TextSpan(text: AppLocalizations.of(context)!.descrFollowing, style: AppStyles.plainText),
          textAlign: TextAlign.start,
        ));
    if (values.isEmpty) {
      children.add(FittedText(
          span: TextSpan(text: AppLocalizations.of(context)!.descrNoFollowing, style: AppStyles.boldText),
          textAlign: TextAlign.start));
    }

    return Column(children: children);
  }
}
