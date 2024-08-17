// Display the details for a specific ranking

import 'package:evf/api/get_rank_details.dart';
import 'package:evf/models/rank_details.dart';
import 'package:evf/widgets/components/rankdetails/details_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class RankDetailsPage extends StatefulWidget {
  final String weapon;
  final String uuid;
  const RankDetailsPage({super.key, required this.weapon, required this.uuid});

  @override
  State<RankDetailsPage> createState() => _RankDetailsState();
}

class _RankDetailsState extends State<RankDetailsPage> {
  RankDetails? details;

  @override
  initState() {
    super.initState();
    getRankDetails(widget.uuid, widget.weapon).then((RankDetails networkData) {
      setState(() => details = networkData);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.titleRankingDetails),
      ),
      body: Center(
        child: details == null ? _loadingAnimation() : _detailScreen(),
      ),
    );
  }

  Widget _loadingAnimation() {
    return LoadingAnimationWidget.staggeredDotsWave(
      color: Colors.white,
      size: 200,
    );
  }

  Widget _detailScreen() {
    return DetailsComponent(
      details: details!,
    );
  }
}
