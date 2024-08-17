import 'package:evf/models/calendar.dart';
import 'package:flutter/material.dart';

import 'calendar_dates.dart';
import 'calendar_texts.dart';

class CalendarComponent extends StatelessWidget {
  final Calendar item;
  const CalendarComponent({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(10, 8, 10, 0),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [CalendarDates(item: item), CalendarTexts(item: item)]));
  }
}
