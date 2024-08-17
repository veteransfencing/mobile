import 'package:evf/assets/evf_icons.dart';
import 'package:evf/models/feed_item.dart';
import 'package:flutter/material.dart';

class FeedLogo extends StatelessWidget {
  final FeedType type;
  const FeedLogo({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    var iconType = Icons.abc;
    switch (type) {
      case FeedType.notification:
        iconType = Icons.notifications_none_outlined;
        break;
      case FeedType.news:
        iconType = EVF.evfLogo;
        break;
      case FeedType.message:
        iconType = Icons.chat_outlined;
        break;
      case FeedType.result:
        iconType = Icons.equalizer_outlined;
        break;
      case FeedType.ranking:
        iconType = Icons.emoji_events_outlined;
        break;
      case FeedType.friends:
        iconType = Icons.groups_2_outlined;
        break;
    }
    return Icon(iconType);
  }
}
