import 'package:evf/l10n/categories.dart';
import 'package:evf/l10n/weapons.dart';
import 'package:evf/models/competition.dart';
import 'package:evf/models/event.dart';
import 'package:evf/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

class CompetitionList extends StatelessWidget {
  final Event event;
  const CompetitionList({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Table(
      border: const TableBorder(),
      columnWidths: const {
        0: FixedColumnWidth(100),
        1: FixedColumnWidth(120),
        2: FixedColumnWidth(50),
        3: FixedColumnWidth(20),
      },
      children: event.competitions.asMap().entries.map<TableRow>((entry) {
        int index = entry.key;
        Competition competition = entry.value;
        return TableRow(
            decoration: BoxDecoration(
              color: ((index % 2) == 0) ? AppStyles.stripes : Colors.white,
            ),
            children: [
              Padding(
                  padding: const EdgeInsets.fromLTRB(4, 2, 4, 2),
                  child: Text(AppLocalizations.of(context)!.resultDate(competition.starts))),
              Padding(
                  padding: const EdgeInsets.fromLTRB(4, 2, 4, 2),
                  child: Text(translateWeapons(context, competition.weapon))),
              Padding(
                  padding: const EdgeInsets.fromLTRB(4, 2, 4, 2),
                  child: Text(translateCategory(context, competition.category))),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 4, 2, 2),
                child: GestureDetector(
                  onTap: () => _onZoomTap(context, competition),
                  child: const Icon(Icons.search_outlined, size: 16),
                ),
              )
            ]);
      }).toList(),
    );
  }

  void _onZoomTap(BuildContext context, Competition competition) {
    GoRouter.of(context).push('/results/${event.id}/${competition.id}');
  }
}
