import 'package:evf/models/account_data.dart';
import 'package:evf/models/follower.dart';
import 'package:evf/styles.dart';
import 'package:evf/widgets/basic/fitted_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'follower_component.dart';

class FollowerList extends StatelessWidget {
  final AccountData data;
  const FollowerList({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final List<Follower> values = data.followers;
    List<Widget> children = values.map<Widget>((Follower f) => FollowerComponent(follower: f)).toList();
    children.insert(
        0,
        FittedText(
          span: TextSpan(text: AppLocalizations.of(context)!.descrFollowers, style: AppStyles.plainText),
          textAlign: TextAlign.start,
        ));
    if (values.isEmpty) {
      children.add(FittedText(
          span: TextSpan(text: AppLocalizations.of(context)!.descrNoFollowers, style: AppStyles.boldText),
          textAlign: TextAlign.start));
    }

    return Column(children: children);
  }
}
