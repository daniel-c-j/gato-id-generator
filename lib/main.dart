import 'package:firebase_auth/firebase_auth.dart';
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
  // * Uncomment this if you need to sign out when switching between Firebase
  // * projects (e.g. Firebase Local emulator vs real Firebase backend)
  // await FirebaseAuth.instance.signOut();
  // * Uncomment below to use local emulator.
  // await appStartup.setupFirebaseEmulators();

  // Entry point
  final root = await appStartup.createRootWidget();
  runApp(root);
}
