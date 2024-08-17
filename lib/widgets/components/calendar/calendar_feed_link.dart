import 'package:evf/environment.dart';
import 'package:evf/models/calendar.dart';
import 'package:evf/widgets/components/calendar/results_feed_button.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CalendarFeedLink extends StatelessWidget {
  final Calendar item;
  const CalendarFeedLink({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return ResultsFeedButton(
      label: AppLocalizations.of(context)!.navResultsFeed,
      callback: _pressIcon,
    );
  }

  Future _pressIcon() async {
    try {
      Environment.debug("launching ${item.feed}");
      await launchUrl(Uri.parse(item.feed));
    } catch (e) {
      // skip any failures to launch the url
      Environment.debug("caught $e");
    }
  }
}
