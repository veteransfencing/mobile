import 'package:evf/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ResultHeader extends StatelessWidget {
  const ResultHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Text.rich(
            TextSpan(text: AppLocalizations.of(context)!.headerEvent),
            style: AppStyles.headerText,
          ),
        ),
        Expanded(
          flex: 1,
          child: Text.rich(
            TextSpan(text: AppLocalizations.of(context)!.headerPosition),
            style: AppStyles.headerText,
          ),
        ),
        Expanded(
          flex: 1,
          child: Text.rich(
            TextSpan(text: AppLocalizations.of(context)!.headerPoints),
            style: AppStyles.headerText,
          ),
        ),
        Expanded(
          flex: 1,
          child: Text.rich(
            TextSpan(text: AppLocalizations.of(context)!.headerDEPoints),
            style: AppStyles.headerText,
          ),
        ),
        Expanded(
          flex: 1,
          child: Text.rich(
            TextSpan(text: AppLocalizations.of(context)!.headerPodiumPoints),
            style: AppStyles.headerText,
          ),
        ),
        Expanded(
          flex: 1,
          child: Text.rich(
            TextSpan(text: AppLocalizations.of(context)!.headerTotalPoints),
            style: AppStyles.headerText,
          ),
        ),
      ],
    );
  }
}
