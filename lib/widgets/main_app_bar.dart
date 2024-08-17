import 'package:flutter/material.dart';

import 'app_logo.dart';
import 'evf_navigation_bar.dart';

class MainAppBar extends StatelessWidget {
  final Widget child;
  const MainAppBar({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const AppLogo(),
      ),
      body: Center(
        child: Container(
          color: Theme.of(context).colorScheme.primary,
          child: Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 255, 255, 255),
              border: Border.all(width: 5, color: Theme.of(context).colorScheme.primary),
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(0),
            child: Center(
              child: child,
            ),
          ),
        ),
      ),
      bottomNavigationBar: const EVFNavigationBar(),
    );
  }
}
