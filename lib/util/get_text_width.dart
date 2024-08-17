import 'package:evf/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

double getTextWidth(String text, TextStyle? style) {
  final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style ?? AppStyles.plainText), maxLines: 1, textDirection: TextDirection.ltr)
    ..layout(minWidth: 0, maxWidth: double.infinity);
  return textPainter.size.width;
}
