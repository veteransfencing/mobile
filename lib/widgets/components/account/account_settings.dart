import 'package:evf/environment.dart';
import 'package:evf/models/account_data.dart';
import 'package:evf/styles.dart';
import 'package:evf/widgets/basic/fitted_text.dart';
import 'package:evf/widgets/components/account/labeled_checkbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AccountSettings extends StatefulWidget {
  final AccountData data;
  const AccountSettings({super.key, required this.data});
  @override
  State<AccountSettings> createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ScrollController();
    return Scrollbar(
        controller: controller,
        child: SingleChildScrollView(
            physics: const ScrollPhysics(),
            controller: controller,
            child: Column(
              children: [
                Text.rich(
                  TextSpan(text: AppLocalizations.of(context)!.titleSettings, style: AppStyles.largeHeader),
                  textAlign: TextAlign.center,
                ),
                FittedText(
                  span:
                      TextSpan(text: AppLocalizations.of(context)!.descrSettingsFollowing, style: AppStyles.plainText),
                  textAlign: TextAlign.start,
                ),
                Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(children: [
                      LabeledCheckbox(
                        padding: const EdgeInsets.only(bottom: 5),
                        label: AppLocalizations.of(context)!.descrFollowResults,
                        checked: _isChecked('fwg_result'),
                        onCheck: (v) => _check('fwg_result', v),
                      ),
                      LabeledCheckbox(
                        label: AppLocalizations.of(context)!.descrFollowRanking,
                        padding: const EdgeInsets.only(bottom: 5),
                        checked: _isChecked('fwg_ranking'),
                        onCheck: (v) => _check('fwg_ranking', v),
                      ),
                      LabeledCheckbox(
                        label: AppLocalizations.of(context)!.descrFollowRegistration,
                        padding: const EdgeInsets.only(bottom: 5),
                        checked: _isChecked('fwg_register'),
                        onCheck: (v) => _check('fwg_register', v),
                      ),
                      LabeledCheckbox(
                        label: AppLocalizations.of(context)!.descrFollowEvent,
                        padding: const EdgeInsets.only(bottom: 5),
                        checked: _isChecked('fwg_event'),
                        onCheck: (v) => _check('fwg_event', v),
                      )
                    ])),
                const SizedBox(height: 10),
                FittedText(
                  span: TextSpan(text: AppLocalizations.of(context)!.descrSettingsFollower, style: AppStyles.plainText),
                  textAlign: TextAlign.start,
                ),
                FittedText(
                  span: TextSpan(text: AppLocalizations.of(context)!.descrAllowBase, style: AppStyles.plainText),
                  textAlign: TextAlign.start,
                ),
                Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(children: [
                      LabeledCheckbox(
                        label: AppLocalizations.of(context)!.descrAllowResults,
                        padding: const EdgeInsets.only(bottom: 5),
                        checked: _isChecked('fwr_result'),
                        onCheck: (v) => _check('fwr_result', v),
                      ),
                      LabeledCheckbox(
                        label: AppLocalizations.of(context)!.descrAllowRanking,
                        padding: const EdgeInsets.only(bottom: 5),
                        checked: _isChecked('fwr_ranking'),
                        onCheck: (v) => _check('fwr_ranking', v),
                      ),
                      LabeledCheckbox(
                        label: AppLocalizations.of(context)!.descrAllowRegistration,
                        padding: const EdgeInsets.only(bottom: 5),
                        checked: _isChecked('fwr_register'),
                        onCheck: (v) => _check('fwr_register', v),
                      ),
                      LabeledCheckbox(
                        label: AppLocalizations.of(context)!.descrAllowHandout,
                        padding: const EdgeInsets.only(bottom: 5),
                        checked: _isChecked('fwr_handout'),
                        onCheck: (v) => _check('fwr_handout', v),
                      ),
                      LabeledCheckbox(
                        label: AppLocalizations.of(context)!.descrAllowCheckin,
                        padding: const EdgeInsets.only(bottom: 5),
                        checked: _isChecked('fwr_checkin'),
                        onCheck: (v) => _check('fwr_checkin', v),
                      ),
                      LabeledCheckbox(
                        label: AppLocalizations.of(context)!.descrAllowCheckout,
                        padding: const EdgeInsets.only(bottom: 5),
                        checked: _isChecked('fwr_checkout'),
                        onCheck: (v) => _check('fwr_checkout', v),
                      )
                    ])),
              ],
            )));
  }

  bool _isChecked(String field) {
    switch (field) {
      case 'fwg_result':
        return Environment.instance.accountProvider.data.preferences.following.contains('result');
      case 'fwg_ranking':
        return Environment.instance.accountProvider.data.preferences.following.contains('ranking');
      case 'fwg_register':
        return Environment.instance.accountProvider.data.preferences.following.contains('register');
      case 'fwg_event':
        return Environment.instance.accountProvider.data.preferences.following.contains('handout') ||
            Environment.instance.accountProvider.data.preferences.following.contains('checkin') ||
            Environment.instance.accountProvider.data.preferences.following.contains('checkout');
      case 'fwr_result':
        return Environment.instance.accountProvider.data.preferences.followers.contains('result');
      case 'fwr_ranking':
        return Environment.instance.accountProvider.data.preferences.followers.contains('ranking');
      case 'fwr_register':
        return Environment.instance.accountProvider.data.preferences.followers.contains('register');
      case 'fwr_handout':
        return Environment.instance.accountProvider.data.preferences.followers.contains('handout');
      case 'fwr_checkin':
        return Environment.instance.accountProvider.data.preferences.followers.contains('checkin');
      case 'fwr_checkout':
        return Environment.instance.accountProvider.data.preferences.followers.contains('checkout');
    }
    return false;
  }

  void _check(String field, bool value) {
    switch (field) {
      case 'fwg_result':
        Environment.instance.accountProvider.updatePreference('following', 'result', !value);
        break;
      case 'fwg_ranking':
        Environment.instance.accountProvider.updatePreference('following', 'ranking', !value);
        break;
      case 'fwg_register':
        Environment.instance.accountProvider.updatePreference('following', 'register', !value);
        break;
      case 'fwg_event':
        Environment.instance.accountProvider.updatePreference('following', 'handout', !value);
        Environment.instance.accountProvider.updatePreference('following', 'checkin', !value);
        Environment.instance.accountProvider.updatePreference('following', 'checkout', !value);
        break;
      case 'fwr_result':
        Environment.instance.accountProvider.updatePreference('follower', 'result', !value);
        break;
      case 'fwr_ranking':
        Environment.instance.accountProvider.updatePreference('follower', 'ranking', !value);
        break;
      case 'fwr_register':
        Environment.instance.accountProvider.updatePreference('follower', 'register', !value);
        break;
      case 'fwr_handout':
        Environment.instance.accountProvider.updatePreference('follower', 'handout', !value);
        break;
      case 'fwr_checkin':
        Environment.instance.accountProvider.updatePreference('follower', 'checkin', !value);
        break;
      case 'fwr_checkout':
        Environment.instance.accountProvider.updatePreference('follower', 'checkout', !value);
        break;
    }
  }
}
