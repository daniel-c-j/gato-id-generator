import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:gato_id_generator/firebase_options.dart';

import 'src/core/_core.dart';

Future<void> main() async {
  // Ensuring widgets binding at startup.
  final WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // Summoning splash screen
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  // Initializing firebase.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Creating app startup instance for further initialization.
  const appStartup = AppStartup();
  await appStartup.initializeApp();
  // Run with remote backend.
  await appStartup.runWithRemote();
  await appStartup.setupFirebaseEmulators();

  // Entry point
  final root = await appStartup.createRootWidget();
  runApp(root);
}
