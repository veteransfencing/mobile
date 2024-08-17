import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

typedef EVFNavigationBarCallback = void Function(int);

class EVFNavigationBar extends StatefulWidget {
  const EVFNavigationBar({super.key});

  @override
  State<EVFNavigationBar> createState() => _EVFNavigationBarState();
}

class _EVFNavigationBarState extends State<EVFNavigationBar> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      onDestinationSelected: (int index) => _onSelected(index, context),
      selectedIndex: currentPageIndex,
      destinations: <Widget>[
        NavigationDestination(
          selectedIcon: const Icon(Icons.home),
          icon: const Icon(Icons.home_outlined),
          label: AppLocalizations.of(context)!.navHome,
        ),
        NavigationDestination(
          selectedIcon: const Icon(Icons.emoji_events),
          icon: const Icon(Icons.emoji_events_outlined),
          label: AppLocalizations.of(context)!.navRanking,
        ),
        NavigationDestination(
          selectedIcon: const Icon(Icons.equalizer),
          icon: const Icon(Icons.equalizer_outlined),
          label: AppLocalizations.of(context)!.navResults,
        ),
        NavigationDestination(
          selectedIcon: const Icon(Icons.calendar_today),
          icon: const Icon(Icons.calendar_today_outlined),
          label: AppLocalizations.of(context)!.navCalendar,
        ),
        NavigationDestination(
          selectedIcon: const Icon(Icons.account_circle),
          icon: const Icon(Icons.account_circle_outlined),
          label: AppLocalizations.of(context)!.navAccount,
        ),
      ],
    );
  }

  void _onSelected(int index, BuildContext context) {
    setState(() => currentPageIndex = index);
    // update the routes
    switch (index) {
      case 0:
        GoRouter.of(context).go('/feed');
        break;
      case 1:
        GoRouter.of(context).go('/ranking');
        break;
      case 2:
        GoRouter.of(context).go('/results');
        break;
      case 3:
        GoRouter.of(context).go('/calendar');
        break;
      case 4:
        GoRouter.of(context).go('/account');
        break;
    }
  }
}
