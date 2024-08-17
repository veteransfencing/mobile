import 'package:evf/models/calendar.dart';
import 'package:evf/styles.dart';
import 'package:flutter/material.dart';

class CalendarLocation extends StatelessWidget {
  final Calendar item;
  const CalendarLocation({required super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Text("${item.location}, ${item.country}", style: AppStyles.italicText);
  }
}
