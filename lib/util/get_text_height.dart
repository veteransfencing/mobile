import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

double getTextHeight(BuildContext context, String text, double padding) {
  double maxWidthFix = MediaQuery.of(context).size.width - padding;
  BoxConstraints constraints = BoxConstraints(
    maxWidth: maxWidthFix, // maxwidth calculated
  );

  RenderParagraph renderObject = RichText(text: TextSpan(text: text)).createRenderObject(context);
  renderObject.layout(constraints);
  return renderObject.getMaxIntrinsicHeight(maxWidthFix);
}
