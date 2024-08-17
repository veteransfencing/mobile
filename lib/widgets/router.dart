import 'package:evf/widgets/pages/pages.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'home_page.dart';

var rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
var navbarNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'navbar');

GoRouter mainRouter() {
  rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
  navbarNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'navbar');

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/feed',
    debugLogDiagnostics: true,
    routes: <RouteBase>[
      ShellRoute(
        navigatorKey: navbarNavigatorKey,
        builder: (BuildContext context, GoRouterState state, Widget child) {
          return HomePage(child: child);
        },
        routes: <RouteBase>[
          GoRoute(
            path: '/feed',
            builder: (BuildContext context, GoRouterState state) {
              return const FeedPage();
            },
          ),
          GoRoute(
            path: '/ranking',
            builder: (BuildContext context, GoRouterState state) {
              return const RankPage();
            },
          ),
          GoRoute(
            path: '/ranking/:weapon/:uuid',
            builder: (BuildContext context, GoRouterState state) {
              return RankDetailsPage(
                weapon: state.pathParameters['weapon']!,
                uuid: state.pathParameters['uuid']!,
              );
            },
          ),
          GoRoute(
            path: '/results',
            builder: (BuildContext context, GoRouterState state) {
              return const ResultsPage();
            },
          ),
          GoRoute(
            path: '/results/:event/:competition',
            builder: (BuildContext context, GoRouterState state) {
              return ResultsDetailPage(
                event: int.tryParse(state.pathParameters['event']!) ?? 0,
                competition: int.tryParse(state.pathParameters['competition']!) ?? 0,
              );
            },
          ),
          GoRoute(
            path: '/calendar',
            builder: (BuildContext context, GoRouterState state) {
              return const CalendarPage();
            },
          ),
          GoRoute(
            path: '/account',
            builder: (BuildContext context, GoRouterState state) {
              return const AccountPage();
            },
          ),
        ],
      )
    ],
  );
}
