import 'package:evf/environment.dart';
import 'package:evf/models/calendar.dart';
import 'package:evf/widgets/components/calendar/calendar_component.dart';
import 'package:flutter/material.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    Environment.instance.calendarProvider.loadItems();
    return ListenableBuilder(
        listenable: Environment.instance.calendarProvider,
        builder: (BuildContext context, Widget? child) {
          // We rebuild the ListView each time the list changes,
          // so that the framework knows to update the rendering.
          final List<Calendar> values = Environment.instance.calendarProvider.list;
          return NotificationListener<OverscrollNotification>(
              onNotification: (OverscrollNotification notification) {
                Environment.debug("overscroll detected ${notification.overscroll}");
                return false;
              },
              child: ListView.builder(
                itemBuilder: (BuildContext context, int index) => CalendarComponent(item: values[index]),
                itemCount: values.length,
              ));
        });
  }
}
