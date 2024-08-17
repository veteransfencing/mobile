import 'package:evf/environment.dart';
import 'package:evf/models/competition.dart';
import 'package:evf/models/event.dart';
import 'package:flutter/material.dart';

import 'results_detail_header.dart';
import 'results_table.dart';

class ResultsDetailComponent extends StatelessWidget {
  final Competition competition;
  final Event event;
  const ResultsDetailComponent({super.key, required this.competition, required this.event});

  @override
  Widget build(BuildContext context) {
    final controller = ScrollController();

    return ListenableBuilder(
        listenable: Environment.instance.resultsProvider,
        builder: (BuildContext context, Widget? child) {
          return Column(children: [
            ResultsDetailHeader(competition: competition, event: event),
            const SizedBox(height: 8),
            Expanded(
              child: Scrollbar(
                controller: controller,
                child: SingleChildScrollView(
                  controller: controller,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                    child: ResultsTable(competition: competition),
                  ),
                ),
              ),
            ),
          ]);
        });
  }
}
