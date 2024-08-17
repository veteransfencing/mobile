// Display the details for a specific ranking

import 'package:evf/environment.dart';
import 'package:evf/models/competition.dart';
import 'package:evf/models/event.dart';
import 'package:evf/widgets/components/resultdetails/results_detail_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ResultsDetailPage extends StatefulWidget {
  final int competition;
  final int event;
  const ResultsDetailPage({super.key, required this.competition, required this.event});

  @override
  State<ResultsDetailPage> createState() => _ResultsDetailState();
}

class _ResultsDetailState extends State<ResultsDetailPage> {
  Competition? competition;
  Event? event;

  @override
  initState() {
    super.initState();
    event = Environment.instance.resultsProvider.findEvent(widget.event);
    competition = Environment.instance.resultsProvider.findCompetition(event!, widget.competition);
    Environment.instance.resultsProvider.loadCompetition(competition!).then((Competition networkData) {
      setState(() => competition = networkData);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.titleResultsDetails),
      ),
      body: Center(
        child: (competition == null || competition!.id == 0) ? _loadingAnimation() : _detailScreen(),
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
    return ResultsDetailComponent(
      competition: competition!,
      event: event!,
    );
  }
}
