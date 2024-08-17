import 'package:evf/environment.dart';
import 'package:evf/styles.dart';
import 'package:flutter/material.dart';

class LabeledCheckbox extends StatelessWidget {
  final String label;
  final bool checked;
  final EdgeInsets padding;

  final void Function(bool) onCheck;
  const LabeledCheckbox(
      {super.key,
      required this.label,
      required this.checked,
      required this.onCheck,
      this.padding = const EdgeInsets.all(0)});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Environment.debug("clicked on LabeledCheckbox $label $checked");
          onCheck(checked);
        },
        child: Padding(
            padding: padding,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(checked ? Icons.check_box_outlined : Icons.check_box_outline_blank),
                Expanded(
                    child: Text.rich(
                  TextSpan(
                    text: label,
                    style: AppStyles.boldText,
                  ),
                  textAlign: TextAlign.start,
                )),
              ],
            )));
  }
}
