import 'package:evf/environment.dart';
import 'package:evf/models/account_data.dart';
import 'package:evf/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'following_list.dart';
import 'follower_list.dart';

class AccountFriends extends StatelessWidget {
  final AccountData data;
  const AccountFriends({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final controller = ScrollController();
    return ListenableBuilder(
        listenable: Environment.instance.followerProvider,
        builder: (BuildContext context, Widget? child) {
          return Scrollbar(
            controller: controller,
            child: SingleChildScrollView(
              physics: const ScrollPhysics(),
              controller: controller,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text.rich(
                    TextSpan(text: AppLocalizations.of(context)!.titleFriends, style: AppStyles.largeHeader),
                    textAlign: TextAlign.center,
                  ),
                  FollowingList(data: data),
                  const SizedBox(height: 20),
                  FollowerList(data: data),
                ],
              ),
            ),
          );
        });
  }
}
