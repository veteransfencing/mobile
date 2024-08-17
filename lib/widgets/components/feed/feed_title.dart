import 'package:evf/styles.dart';
import 'package:flutter/material.dart';

class FeedTitle extends StatelessWidget {
  final bool isExpanded;
  final bool canExpand;
  final String title;
  const FeedTitle({super.key, required this.isExpanded, required this.canExpand, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
          child: RichText(
        text: TextSpan(
          style: AppStyles.headerText,
          text: title,
        ),
        textAlign: TextAlign.left,
      )),
      if (canExpand) Icon(isExpanded ? Icons.arrow_drop_down : Icons.arrow_right)
    ]);
  }
}
