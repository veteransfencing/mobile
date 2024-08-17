import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:evf/widgets/main_app.dart';
import 'package:evf/env/dev.dart';
import 'environment.dart';
import 'initialization.dart';

Future<void> main() async {
  // this sets the static Environment.instance
  Environment(flavor: Development());
  Environment.debug("Starting initialization");
  await initialization();
  Environment.debug("running post-initialization, but not waiting for that");
  Environment.instance.postInitialize();
  Environment.debug("Initialization finished, removing splash");
  FlutterNativeSplash.remove();
  Environment.debug("Creating MainApp");
  runApp(const MainApp(doDebug: true));
  Environment.debug("End of main app loop");
}
