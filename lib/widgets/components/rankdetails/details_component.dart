import 'package:evf/l10n/categories.dart';
import 'package:evf/l10n/weapons.dart';
import 'package:evf/models/rank_details.dart';
import 'package:evf/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'result_list.dart';

class DetailsComponent extends StatelessWidget {
  final RankDetails details;
  const DetailsComponent({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            SizedBox(
                width: 70,
                child: Text.rich(TextSpan(style: AppStyles.boldText, text: AppLocalizations.of(context)!.labelName))),
            Text(details.fencer.fullName())
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            SizedBox(
                width: 70,
                child:
                    Text.rich(TextSpan(style: AppStyles.boldText, text: AppLocalizations.of(context)!.labelCountry))),
            Text(details.fencer.country)
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            SizedBox(
                width: 70,
                child: Text.rich(TextSpan(style: AppStyles.boldText, text: AppLocalizations.of(context)!.labelWeapon))),
            Text(translateWeapons(context, details.weapon))
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            SizedBox(
                width: 70,
                child:
                    Text.rich(TextSpan(style: AppStyles.boldText, text: AppLocalizations.of(context)!.labelCategory))),
            Text(translateCategory(context, details.category))
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            SizedBox(
                width: 70,
                child: Text.rich(
                    TextSpan(style: AppStyles.boldText, text: AppLocalizations.of(context)!.labelCurrentRank))),
            Text("${details.position} (${details.points.toStringAsFixed(2)})")
          ]),
          const SizedBox(height: 10.0),
          Expanded(flex: 1, child: ResultList(details: details)),
        ],
      ),
    );
  }
}
