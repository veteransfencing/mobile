import 'package:evf/environment.dart';
import 'package:evf/l10n/categories.dart';
import 'package:evf/l10n/weapons.dart';
import 'package:evf/models/ranking.dart';
import 'package:evf/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RankingTitle extends StatelessWidget {
  final Ranking ranking;
  const RankingTitle({super.key, required this.ranking});

  @override
  Widget build(BuildContext context) {
    String category = translateCategory(context, ranking.category);
    String weapon = translateWeapons(context, ranking.weapon);
    String title = AppLocalizations.of(context)!.titleRanking(category, weapon, ranking.date);
    Environment.debug("${ranking.category} says $category, ${ranking.weapon} says $weapon, title is $title");

    return RichText(
      text: TextSpan(
        style: AppStyles.headerText,
        text: title,
      ),
      textAlign: TextAlign.left,
    );
  }
}
