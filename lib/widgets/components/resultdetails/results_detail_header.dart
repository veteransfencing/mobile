import 'package:evf/l10n/categories.dart';
import 'package:evf/l10n/weapons.dart';
import 'package:evf/models/competition.dart';
import 'package:evf/models/event.dart';
import 'package:evf/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ResultsDetailHeader extends StatelessWidget {
  final Event event;
  final Competition competition;
  const ResultsDetailHeader({super.key, required this.event, required this.competition});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text.rich(
          TextSpan(text: event.name, style: AppStyles.largeHeader),
          textAlign: TextAlign.center,
        ),
        Text.rich(TextSpan(text: "${event.location}, ${event.country}", style: AppStyles.plainText)),
        Text.rich(
          TextSpan(
              text:
                  "${translateWeapons(context, competition.weapon)} ${translateCategory(context, competition.category)}"),
          style: AppStyles.plainText,
        ),
        Text.rich(
          TextSpan(
            text: AppLocalizations.of(context)!.resultDate(competition.starts),
            style: AppStyles.italicText,
          ),
        ),
      ],
    );
  }
}
