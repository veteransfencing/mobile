import 'package:evf/models/rank_details.dart';
import 'package:evf/models/rank_result.dart';
import 'package:flutter/material.dart';

import 'result_component.dart';
import 'result_header.dart';

class ResultList extends StatelessWidget {
  final RankDetails details;

  const ResultList({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    return ListView(children: _createRows(context, details.results));
  }

  List<Widget> _createRows(BuildContext context, List<RankResult> results) {
    List<Widget> retval = [const ResultHeader()];
    for (var i = 0; i < results.length; i++) {
      final RankResult result = results[i];

      retval.add(ResultComponent(result: result));
    }
    return retval;
  }
}
