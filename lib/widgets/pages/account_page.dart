import 'package:evf/environment.dart';
import 'package:evf/widgets/components/account/account_dashboard.dart';
import 'package:flutter/material.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    Environment.debug("loading new account provider items");
    Environment.instance.accountProvider.loadItems();
    return ListenableBuilder(
        listenable: Environment.instance.accountProvider,
        builder: (BuildContext context, Widget? child) {
          Environment.debug("rebuilding account dashboard");
          return AccountDashboard(data: Environment.instance.accountProvider.data);
        });
  }
}
