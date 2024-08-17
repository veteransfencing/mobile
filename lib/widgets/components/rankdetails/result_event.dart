import 'package:auto_size_text/auto_size_text.dart';
import 'package:evf/l10n/categories.dart';
import 'package:evf/l10n/weapons.dart';
import 'package:evf/models/rank_result.dart';
import 'package:evf/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ResultEvent extends StatelessWidget {
  final RankResult result;
  const ResultEvent({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AutoSizeText(result.event, style: AppStyles.boldText),
        const SizedBox(width: 4),
        Text.rich(
            TextSpan(
              text: AppLocalizations.of(context)!.resultDate(result.date),
            ),
            style: AppStyles.plainText),
        const SizedBox(width: 4),
        Text.rich(TextSpan(text: weaponCat(context)), style: AppStyles.plainText)
      ],
    );
  }

  String weaponCat(BuildContext context) {
    return "${translateWeaponsShort(context, result.weapon)}${translateCategoryShort(context, result.category)}";
  }
}
