import 'package:evf/models/rank_result.dart';
import 'package:evf/styles.dart';
import 'package:flutter/material.dart';

class ResultPoints extends StatelessWidget {
  final RankResult result;
  const ResultPoints({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const Expanded(flex: 1, child: Text('')),
        Expanded(flex: 1, child: Text("${result.position}/${result.entries}")),
        Expanded(flex: 1, child: Text(result.points.toStringAsFixed(2))),
        Expanded(flex: 1, child: Text(result.de.toStringAsFixed(2))),
        Expanded(flex: 1, child: Text(result.podium.toStringAsFixed(2))),
        Expanded(flex: 1, child: Text.rich(TextSpan(text: result.total.toStringAsFixed(2), style: AppStyles.boldText))),
      ],
    );
  }
}
