// ignore_for_file: depend_on_referenced_packages

import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gato_id_generator/src/core/local_db/hive_registrar.g.dart';
import 'package:hive_ce/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gato_id_generator/src/core/constants/_constants.dart';
import 'package:gato_id_generator/src/core/_core.dart';

import 'goldens/golden_robot.dart';
import 'src/presentation/auth/auth_robot.dart';
import 'src/presentation/generate/generate_robot.dart';
import 'src/presentation/home/home_robot.dart';

@visibleForTesting
class Robot {
  Robot(this.tester)
      : home = HomeRobot(tester),
        auth = AuthRobot(tester),
        generate = GenerateRobot(tester),
        golden = GoldenRobot(tester);

  final WidgetTester tester;
  final GoldenRobot golden;
  final GenerateRobot generate;
  final AuthRobot auth;
  final HomeRobot home;

  Future<void> _necessaryIntializations() async {
    try {
      await EasyLocalization.ensureInitialized();
      Default.init();
      NetConsts.init();
      await AppInfo.init(const PackageInfoWrapper());

      // Hive-specific
      Hive.init(Directory("temp").path);
      Hive.registerAdapters();
      await Hive.initBoxes();
    } catch (e) {
      if (kDebugMode) {
        print("ERROR");
        print(e);
      }
    }
  }

  Future<void> pumpApp() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    WidgetsFlutterBinding.ensureInitialized();

    // Simulation requirements.
    canListenToNetworkStatusChange = false;

    // Easy_localization test requirement.
    SharedPreferences.setMockInitialValues({});

    // ! Must be before appStartup.
    await _necessaryIntializations();
    try {
      // Try to reset first.
      await getIt.reset(dispose: true);
    } catch (e) {
      // Nothing
    }

    // Creating app startup instance for initialization.
    const appStartup = AppStartup();
    try {
      await appStartup.initializeApp(minimumTest: true);
      await appStartup.runWithLocal();
    } catch (e) {
      // Do nothing, just to prevent multiple getIt register.
    }

    // * Entry point of the app
    final root = await appStartup.createRootWidget();
    await tester.pumpWidget(root);
    await tester.pumpAndSettle();
  }
}
