import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:evf/widgets/router.dart' as router;

Future<bool?> alert(String descr) async {
  return await showDialog<bool>(
      context: router.rootNavigatorKey.currentState!.context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text(AppLocalizations.of(context)!.titleAlert),
          contentPadding: const EdgeInsets.all(10),
          children: [
            Text(descr),
            Row(children: [
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: Text(AppLocalizations.of(context)!.labelOk),
              ),
            ])
          ],
        );
      });
}
