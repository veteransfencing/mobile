import 'package:evf/environment.dart';
import 'package:evf/models/ranking.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'ranking_table.dart';
import 'ranking_title.dart';

class RankingDisplay extends StatelessWidget {
  final String category;
  final String weapon;
  const RankingDisplay({super.key, required this.category, required this.weapon});

  @override
  Widget build(BuildContext context) {
    final controller = ScrollController();
    return ListenableBuilder(
        listenable: Environment.instance.rankingProvider,
        builder: (BuildContext context, Widget? child) {
          Environment.debug("getting ranking for $category and $weapon");
          // this returns a ranking, even if there is none yet. But the
          // listenable will notify us when a new ranking has arrived
          final Ranking ranking = Environment.instance.rankingProvider.getRankingFor(category, weapon);
          Environment.debug("ranking has ${ranking.positions.length} entries");

          Environment.debug("rebuilding ranking");
          return Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  RankingTitle(ranking: ranking),
                  Expanded(
                    child: Scrollbar(
                      controller: controller,
                      child: SingleChildScrollView(
                          controller: controller,
                          child: RankingTable(
                            ranking: ranking,
                            onFavoriteTap: _performFavoriteAction,
                            onZoomTap: (String uuid) => _performZoomAction(uuid, context),
                          )),
                    ),
                  )
                ],
              ));
        });
  }

  void _performFavoriteAction(String uuid) async {
    Environment.debug("clicked on favorite $uuid");
    await Environment.instance.followerProvider.toggleFollowing(uuid);
  }

  void _performZoomAction(String uuid, BuildContext context) {
    Environment.debug("zooming into $uuid");
    GoRouter.of(context).push('/ranking/$weapon/$uuid');
  }
}
