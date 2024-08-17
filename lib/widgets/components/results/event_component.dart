import 'package:evf/models/event.dart';
import 'package:evf/widgets/components/results/competition_list.dart';
import 'package:flutter/material.dart';

import 'event_title.dart';

class EventComponent extends StatefulWidget {
  final Event event;

  const EventComponent({super.key, required this.event});

  @override
  State<EventComponent> createState() => _EventComponentState();
}

class _EventComponentState extends State<EventComponent> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
        child: GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                EventTitle(event: widget.event, isExpanded: _isExpanded),
                if (_isExpanded) CompetitionList(event: widget.event)
              ],
            )));
  }
}
