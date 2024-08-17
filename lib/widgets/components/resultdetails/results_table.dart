import 'package:auto_size_text/auto_size_text.dart';
import 'package:evf/environment.dart';
import 'package:evf/models/competition.dart';
import 'package:evf/models/competition_result.dart';
import 'package:evf/styles.dart';
import 'package:flutter/material.dart';

typedef TapCallback = void Function(String);

class ResultsTable extends StatelessWidget {
  final Competition competition;

  const ResultsTable({super.key, required this.competition});

  @override
  Widget build(BuildContext context) {
    return Table(
        border: const TableBorder(),
        columnWidths: const {
          0: FixedColumnWidth(30),
          1: FixedColumnWidth(25),
          2: FlexColumnWidth(1),
          3: FlexColumnWidth(1),
          4: FixedColumnWidth(39),
          5: FixedColumnWidth(52),
        },
        children: competition.results.asMap().entries.map<TableRow>((entry) {
          final int index = entry.key;
          final CompetitionResult position = entry.value;
          return TableRow(
            decoration: BoxDecoration(
              color: ((index % 2) == 0) ? AppStyles.stripes : Colors.white,
            ),
            children: [
              Align(alignment: Alignment.centerRight, child: Text("${position.position.toString()}.")),
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 2, 4, 2),
                child: ListenableBuilder(
                    listenable: Environment.instance.followerProvider,
                    builder: (BuildContext context, Widget? child) {
                      bool followerIsSet =
                          Environment.instance.followerProvider.following.containsKey(position.fencer.id);
                      return GestureDetector(
                        onTap: () => _onFavoriteTap(position.fencer.id),
                        child: Icon(
                          followerIsSet ? Icons.favorite : Icons.favorite_outline,
                          size: 16,
                          color: followerIsSet ? Colors.red : Colors.black,
                        ),
                      );
                    }),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 2, 4, 2),
                child: AutoSizeText(
                  position.fencer.lastName,
                  maxFontSize: 18,
                  minFontSize: 8,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 2, 4, 2),
                child: AutoSizeText(
                  position.fencer.firstName,
                  maxFontSize: 18,
                  minFontSize: 8,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 2, 0, 2),
                child: Text(position.fencer.countryShort),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 2, 0, 2),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    position.points.toStringAsFixed(2),
                  ),
                ),
              ),
            ],
          );
        }).toList());
  }

  void _onFavoriteTap(String uuid) async {
    Environment.debug("clicked on favorite $uuid");
    await Environment.instance.followerProvider.toggleFollowing(uuid);
  }
}
