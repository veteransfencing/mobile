import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:evf/widgets/main_app.dart';
import 'package:evf/env/prod.dart';
import 'environment.dart';
import 'initialization.dart';

Future<void> main() async {
  // this sets the static Environment.instance
  Environment(flavor: Production());
  await initialization();
  Environment.instance.postInitialize();
  FlutterNativeSplash.remove();
  runApp(const MainApp(doDebug: false));
}
