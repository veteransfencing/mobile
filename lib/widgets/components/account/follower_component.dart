import 'package:evf/environment.dart';
import 'package:evf/models/follower.dart';
import 'package:evf/styles.dart';
import 'package:evf/widgets/basic/label_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FollowerComponent extends StatelessWidget {
  final Follower follower;

  const FollowerComponent({super.key, required this.follower});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
        child: Row(children: [
          Expanded(
              child: Text.rich(
            TextSpan(
              text: _getName(context),
              style: AppStyles.boldText,
            ),
          )),
          if (!follower.blocked)
            LabelButton(
              label: AppLocalizations.of(context)!.labelBlock,
              callback: () => _block(true),
            ),
          if (follower.blocked)
            LabelButton(
              label: AppLocalizations.of(context)!.labelUnblock,
              callback: () => _block(false),
            ),
        ]));
  }

  void _block(bool doBlock) async {
    await Environment.instance.accountProvider.block(follower.user, doBlock);
  }

  String _getName(BuildContext context) {
    if (follower.fencer.id != '') {
      return follower.fencer.fullName();
    }
    return AppLocalizations.of(context)!.labelAnonymous;
  }
}
