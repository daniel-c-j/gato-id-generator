import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'src/core/_core.dart';

Future<void> main() async {
  // Ensuring widgets binding at startup.
  final WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // Summoning splash screen
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  // Creating app startup instance for further initialization.
  const appStartup = AppStartup();
  await appStartup.initializeApp();
  // Run with local backend.
  await appStartup.runWithLocal();

  // Entry point
  final root = await appStartup.createRootWidget();
  runApp(root);
}
