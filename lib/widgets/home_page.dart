import 'package:flutter/material.dart';
import 'main_app_bar.dart';

class HomePage extends StatelessWidget {
  final Widget child;
  const HomePage({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MainAppBar(child: child);
  }
}
