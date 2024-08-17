import 'package:flutter/material.dart';

class WidthBox extends StatelessWidget {
  final Widget child;
  final double width;
  final EdgeInsetsGeometry? padding;

  const WidthBox({super.key, required this.child, required this.width, this.padding});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.all(0),
      child: ConstrainedBox(
        constraints: BoxConstraints(minWidth: width, maxWidth: width),
        child: child,
      ),
    );
  }
}
