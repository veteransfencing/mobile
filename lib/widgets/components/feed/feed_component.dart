import 'package:evf/models/feed_item.dart';
import 'package:flutter/material.dart';
import 'feed_logo.dart';
import 'feed_text.dart';

class FeedComponent extends StatefulWidget {
  final FeedItem item;
  const FeedComponent({super.key, required this.item});

  @override
  State<FeedComponent> createState() => _FeedComponentState();
}

class _FeedComponentState extends State<FeedComponent> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
        child: GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  FeedLogo(type: widget.item.type),
                  FeedText(item: widget.item, isExpanded: _isExpanded),
                ])));
  }
/*
  String _reduceText(String content) {
    if (content.length < 45) {
      return content;
    }
    var str = content.substring(0, 42);
    RegExp pattern = RegExp(r'[\r\n\t]');
    return '${str.split(pattern).take(1).first} ...';
  }
  */
}
