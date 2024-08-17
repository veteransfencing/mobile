import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

String translateWeapons(BuildContext context, String weapon) {
  switch (weapon) {
    case 'MF':
      return AppLocalizations.of(context)!.labelWeaponMF;
    case 'ME':
      return AppLocalizations.of(context)!.labelWeaponME;
    case 'MS':
      return AppLocalizations.of(context)!.labelWeaponMS;
    case 'WF':
      return AppLocalizations.of(context)!.labelWeaponWF;
    case 'WE':
      return AppLocalizations.of(context)!.labelWeaponWE;
    case 'WS':
      return AppLocalizations.of(context)!.labelWeaponWS;
  }
  return AppLocalizations.of(context)!.labelWeaponMF;
}

String translateWeaponsShort(BuildContext context, String weapon) {
  switch (weapon) {
    case 'MF':
      return AppLocalizations.of(context)!.labelWeaponMFShort;
    case 'ME':
      return AppLocalizations.of(context)!.labelWeaponMEShort;
    case 'MS':
      return AppLocalizations.of(context)!.labelWeaponMSShort;
    case 'WF':
      return AppLocalizations.of(context)!.labelWeaponWFShort;
    case 'WE':
      return AppLocalizations.of(context)!.labelWeaponWEShort;
    case 'WS':
      return AppLocalizations.of(context)!.labelWeaponWSShort;
  }
  return AppLocalizations.of(context)!.labelWeaponMFShort;
}
