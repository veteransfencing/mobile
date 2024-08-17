import 'package:auto_size_text/auto_size_text.dart';
import 'package:evf/environment.dart';
import 'package:evf/models/ranking.dart';
import 'package:evf/models/ranking_position.dart';
import 'package:evf/styles.dart';
import 'package:flutter/material.dart';

typedef TapCallback = void Function(String);

class RankingTable extends StatelessWidget {
  final Ranking ranking;
  final TapCallback onFavoriteTap;
  final TapCallback onZoomTap;

  const RankingTable({super.key, required this.ranking, required this.onFavoriteTap, required this.onZoomTap});

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
          6: FixedColumnWidth(25),
        },
        children: ranking.positions.asMap().entries.map<TableRow>((entry) {
          final int index = entry.key;
          final RankingPosition position = entry.value;
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
                      bool followerIsSet = Environment.instance.followerProvider.following.containsKey(position.id);
                      return GestureDetector(
                        onTap: () => onFavoriteTap(position.id),
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
                  position.lastName,
                  maxFontSize: 18,
                  minFontSize: 8,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 2, 4, 2),
                child: AutoSizeText(
                  position.firstName,
                  maxFontSize: 18,
                  minFontSize: 8,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 2, 0, 2),
                child: Text(position.country),
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
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 4, 2, 2),
                child: GestureDetector(
                  onTap: () => onZoomTap(position.id),
                  child: const Icon(Icons.search_outlined, size: 16),
                ),
              ),
            ],
          );
        }).toList());
  }
}
