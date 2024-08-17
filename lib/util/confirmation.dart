import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:evf/widgets/router.dart' as router;

Future<bool?> confirmation(String descr) async {
  BuildContext context = router.rootNavigatorKey.currentState!.context;
  return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text(AppLocalizations.of(context)!.titleConfirmation),
          contentPadding: const EdgeInsets.all(10),
          children: [
            Text(descr),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: Text(AppLocalizations.of(context)!.labelCancel),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: Text(AppLocalizations.of(context)!.labelOk),
                ),
              ],
            )
          ],
        );
      });
}
