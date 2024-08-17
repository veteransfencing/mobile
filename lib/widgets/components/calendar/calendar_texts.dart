import 'package:evf/environment.dart';
import 'package:evf/models/calendar.dart';
import 'package:evf/styles.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'calendar_feed_link.dart';
import 'calendar_location.dart';

class CalendarTexts extends StatelessWidget {
  final Calendar item;
  const CalendarTexts({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 2, 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                    height: 36,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                            child: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                                child: RichText(
                                  text: TextSpan(
                                    style: AppStyles.headerText,
                                    text: item.title,
                                  ),
                                  textAlign: TextAlign.left,
                                ))),
                        if (item.url.isNotEmpty)
                          IconButton(
                            icon: const Icon(Icons.link_outlined),
                            onPressed: _pressIcon,
                          )
                      ],
                    )),
                Container(
                    transform: Matrix4.translationValues(0.0, -8.0, 0.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CalendarLocation(key: key, item: item),
                          if (item.content.isNotEmpty)
                            Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                                child: RichText(
                                  text: TextSpan(
                                    style: AppStyles.plainText,
                                    text: item.content,
                                  ),
                                  textAlign: TextAlign.left,
                                )),
                          if (item.feed.isNotEmpty) CalendarFeedLink(item: item)
                        ]))
              ],
            )));
  }

  Future _pressIcon() async {
    try {
      Environment.debug("launching ${item.url}");
      await launchUrl(Uri.parse(item.url));
    } catch (e) {
      // skip any failures to launch the url
      Environment.debug("caught $e");
    }
  }
}
