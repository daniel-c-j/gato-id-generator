// coverage:ignore-file
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'src/core/_core.dart';

Future<void> main() async {
  // * Ensuring widgets binding at startup.
  final WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // * Summoning splash screen
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // * Creating app startup instance for further initialization.
  const appStartup = AppStartup();
  await appStartup.initializeApp();

  // * Run with remote backend.
  final backendType = RemoteBackendType.firebase;
  await appStartup.runWithRemote(backendType);

  // * Uncomment this if you need to sign out when switching between Firebase
  // * projects (e.g. Firebase Local emulator vs real Firebase backend)
  // await FirebaseAuth.instance.signOut();
  // * Uncomment below to use local emulator.
  // await appStartup.setupFirebaseEmulators();

  // * Entry point
  final root = await appStartup.createRootWidget();
  runApp(root);
}
