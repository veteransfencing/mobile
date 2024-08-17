import 'package:flutter/material.dart';

class FittedText extends StatelessWidget {
  final TextSpan span;
  final TextAlign textAlign;

  const FittedText({super.key, required this.span, this.textAlign = TextAlign.start});

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: double.infinity, child: Text.rich(span, textAlign: textAlign));
  }
}
