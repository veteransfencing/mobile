import 'package:evf/models/event.dart';
import 'package:evf/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EventTitle extends StatelessWidget {
  final bool isExpanded;
  final Event event;
  const EventTitle({super.key, required this.isExpanded, required this.event});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      SizedBox(
          width: 50,
          child: Text.rich(TextSpan(
            text: AppLocalizations.of(context)!.calendarDate(event.opens),
            style: AppStyles.italicText,
          ))),
      Expanded(
          child: RichText(
        text: TextSpan(
          style: AppStyles.headerText,
          text: event.name,
        ),
        textAlign: TextAlign.left,
      )),
      Icon(isExpanded ? Icons.arrow_drop_down : Icons.arrow_right)
    ]);
  }
}
