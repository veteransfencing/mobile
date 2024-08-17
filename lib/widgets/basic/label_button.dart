import 'package:evf/styles.dart';
import 'package:flutter/material.dart';

class LabelButton extends StatelessWidget {
  final String label;
  final void Function() callback;
  const LabelButton({super.key, required this.label, required this.callback});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 20,
        width: 55,
        child: ElevatedButton(
          onPressed: callback,
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.primary),
              foregroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.onPrimary),
              shape: MaterialStateProperty.all(
                const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(0.5),
                  ),
                ),
              ),
              padding: MaterialStateProperty.all(const EdgeInsets.fromLTRB(0, 0, 0, 0))),
          child: Text(label, style: AppStyles.feedButton),
        ));
  }
}
