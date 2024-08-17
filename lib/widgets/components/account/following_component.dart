import 'package:evf/environment.dart';
import 'package:evf/models/follower.dart';
import 'package:evf/styles.dart';
import 'package:evf/widgets/basic/label_button.dart';
import 'package:evf/widgets/components/account/following_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FollowingComponent extends StatefulWidget {
  final Follower follower;

  const FollowingComponent({super.key, required this.follower});

  @override
  State<FollowingComponent> createState() => _FollowingComponentState();
}

class _FollowingComponentState extends State<FollowingComponent> {
  bool isExpanded = false;

  _FollowingComponentState();

  @override
  Widget build(BuildContext context) {
    Environment.debug("rebuilding following component with state ${widget.follower.fencer.fullName()} ${widget.key}");
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
            onTap: () {
              setState(() => isExpanded = !isExpanded);
            },
            child: Row(children: [
              Expanded(
                  child: Text.rich(
                TextSpan(
                  text: widget.follower.fencer.fullName(),
                  style: AppStyles.boldText,
                ),
              )),
              Icon(isExpanded ? Icons.arrow_drop_down : Icons.arrow_right),
            ])),
        LabelButton(
          label: AppLocalizations.of(context)!.labelUnfollow,
          callback: _unfollow,
        ),
        if (isExpanded) FollowingSettings(following: widget.follower),
      ],
    );
  }

  void _unfollow() async {
    await Environment.instance.accountProvider.unfollow(widget.follower.fencer.id);
  }
}
