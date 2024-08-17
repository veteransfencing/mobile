import 'package:evf/environment.dart';
import 'package:evf/models/feed_item.dart';
import 'package:evf/widgets/components/feed/feed_component.dart';
import 'package:flutter/material.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    Environment.instance.feedProvider.loadItems();
    return ListenableBuilder(
        listenable: Environment.instance.feedProvider,
        builder: (BuildContext context, Widget? child) {
          // We rebuild the ListView each time the list changes,
          // so that the framework knows to update the rendering.
          final List<FeedItem> values = Environment.instance.feedProvider.list.list;
          return ListView.builder(
            itemBuilder: (BuildContext context, int index) => FeedComponent(item: values[index]),
            itemCount: values.length,
          );
        });
  }
}
