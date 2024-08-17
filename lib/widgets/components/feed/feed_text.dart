import 'package:evf/models/feed_item.dart';
import 'package:evf/util/get_text_height.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import 'feed_title.dart';

class FeedText extends StatelessWidget {
  final FeedItem item;
  final bool isExpanded;
  const FeedText({super.key, required this.item, required this.isExpanded});

  @override
  Widget build(BuildContext context) {
    bool canExpand = hasMoreLines(context);
    return Expanded(
        child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                FeedTitle(title: item.title, isExpanded: isExpanded, canExpand: canExpand),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: isExpanded ? null : 36,
                  child: Html(
                    data: item.content,
                  ),
                ),
              ],
            )));
  }

  bool hasMoreLines(BuildContext context) {
    final height = getTextHeight(context, item.content, 64);
    final defaultHeight = (DefaultTextStyle.of(context).style.fontSize ?? 28);
    return height > (1.3 * defaultHeight);
  }
}
