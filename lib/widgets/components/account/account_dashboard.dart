import 'package:evf/models/account_data.dart';
import 'package:flutter/material.dart';

import 'account_email.dart';
import 'account_fencer.dart';
import 'account_friends.dart';
import 'account_settings.dart';

class AccountDashboard extends StatelessWidget {
  final AccountData data;
  const AccountDashboard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 4,
        child: Column(
          children: [
            const TabBar(tabs: [
              Tab(icon: Icon(Icons.account_circle_outlined)),
              Tab(icon: Icon(Icons.link_outlined)),
              Tab(icon: Icon(Icons.people_outline)),
              Tab(icon: Icon(Icons.notifications_none_outlined)),
            ]),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: TabBarView(
                  children: [
                    AccountEmail(data: data),
                    AccountFencer(data: data),
                    AccountFriends(data: data),
                    AccountSettings(data: data),
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
