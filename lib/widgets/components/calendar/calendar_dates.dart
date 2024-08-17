import 'package:evf/models/calendar.dart';
import 'package:evf/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CalendarDates extends StatelessWidget {
  final Calendar item;
  const CalendarDates({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
        child: SizedBox(
            width: 50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: AppStyles.calendarDates,
                    text: formattedDate(context, item.startDate),
                  ),
                  textAlign: TextAlign.left,
                ),
                if (_moreDates())
                  RichText(
                    text: TextSpan(
                      style: AppStyles.calendarDates,
                      text: formattedDate(context, item.endDate),
                    ),
                    textAlign: TextAlign.left,
                  )
              ],
            )));
  }

  bool _moreDates() {
    return !DateUtils.isSameDay(item.startDate, item.endDate);
  }

  String formattedDate(BuildContext context, DateTime dt) {
    return AppLocalizations.of(context)!.calendarDate(dt);
  }
}
