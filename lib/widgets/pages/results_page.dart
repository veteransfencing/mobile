import 'package:evf/environment.dart';
import 'package:evf/models/event.dart';
import 'package:evf/styles.dart';
import 'package:evf/widgets/components/results/event_component.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';

class ResultsPage extends StatelessWidget {
  const ResultsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // preload the results from cache, or from the network if we do not have any yet
    Environment.instance.resultsProvider.loadItems();
    return ListenableBuilder(
        listenable: Environment.instance.resultsProvider,
        builder: (BuildContext context, Widget? child) {
          final themeData = Theme.of(context);
          // We rebuild the ListView each time the list changes,
          // so that the framework knows to update the rendering.
          final List<Event> values = Environment.instance.resultsProvider.list;
          return GroupedListView(
            elements: values,
            groupBy: (element) => element.year.toString(),
            itemComparator: (e1, e2) {
              int cmp = e1.opens.compareTo(e2.opens);
              if (cmp != 0) return cmp;
              return e1.name.compareTo(e2.name);
            },
            groupSeparatorBuilder: (String groupByValue) => DecoratedBox(
              decoration: BoxDecoration(
                color: themeData.secondaryHeaderColor,
              ),
              child: Text.rich(
                TextSpan(text: groupByValue, style: AppStyles.largeHeader),
                textAlign: TextAlign.center,
              ),
            ),
            itemBuilder: (BuildContext context, dynamic content) => EventComponent(event: content as Event),
            useStickyGroupSeparators: true,
            order: GroupedListOrder.DESC,
          );
        });
  }
}
