import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'src/core/_core.dart';

// TODO Read this.
// ! Do note, that while this is a template, that does not mean it can be used right away, do make sure the plugins
// ! configuration for specific natives. Such as for Dio, for Android to provide the xml for internet permission.
Future<void> main() async {
  // Ensuring widgets binding at startup.
  final WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // Summoning splash screen
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Creating app startup instance for initialization.
  const appStartup = AppStartup();
  final root = await appStartup.createRootWidget();

  // Entry point
  runApp(root);
}
