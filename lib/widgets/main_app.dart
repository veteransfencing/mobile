import 'package:evf/environment.dart';
import 'package:evf/providers/account_provider.dart';
import 'package:evf/providers/calendar_provider.dart';
import 'package:evf/providers/feed_provider.dart';
import 'package:evf/providers/follower_provider.dart';
import 'package:evf/providers/ranking_provider.dart';
import 'package:evf/providers/result_provider.dart';
import 'package:evf/providers/status_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'router.dart';

class MainApp extends StatelessWidget {
  final bool doDebug;

  const MainApp({super.key, required this.doDebug});

  @override
  Widget build(BuildContext context) {
    Environment.instance.localizations = AppLocalizations.of(context);
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<StatusProvider>(create: (context) => Environment.instance.statusProvider),
          ChangeNotifierProvider<FeedProvider>(create: (context) => Environment.instance.feedProvider),
          ChangeNotifierProvider<CalendarProvider>(create: (context) => Environment.instance.calendarProvider),
          ChangeNotifierProvider<RankingProvider>(create: (context) => Environment.instance.rankingProvider),
          ChangeNotifierProvider<FollowerProvider>(create: (context) => Environment.instance.followerProvider),
          ChangeNotifierProvider<ResultProvider>(create: (context) => Environment.instance.resultsProvider),
          ChangeNotifierProvider<AccountProvider>(create: (context) => Environment.instance.accountProvider),
        ],
        child: MaterialApp.router(
          routerConfig: mainRouter(),
          debugShowCheckedModeBanner: doDebug,
          title: "MyEVF",
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 0, 51, 102)),
            useMaterial3: true,
          ),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ));
  }
}
