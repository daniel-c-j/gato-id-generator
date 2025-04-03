// ignore_for_file: depend_on_referenced_packages

import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gato_id_generator/src/core/constants/_constants.dart';
import 'package:gato_id_generator/src/core/_core.dart';

import 'goldens/golden_robot.dart';

@visibleForTesting
class Robot {
  Robot(this.tester) : golden = GoldenRobot(tester);

  final WidgetTester tester;
  final GoldenRobot golden;

  Future<void> _necessaryIntializations() async {
    try {
      await EasyLocalization.ensureInitialized();
      Default.init();
      NetConsts.init();
      await AppInfo.init(const PackageInfoWrapper());

      // Hive-specific
      Hive.init((await getTemporaryDirectory()).path);
      Hive.registerAdapters();
      await Hive.initBoxes();
    } catch (e) {
      // Simply put, they're all initialized.
      log(e.toString());
    }
  }

  Future<void> pumpApp({bool isGolden = false, ProviderContainer? container}) async {
    WidgetsFlutterBinding.ensureInitialized();

    // Simulation requirements.
    canListenToNetworkStatusChange = false;

    // Easy_localization test requirement.
    SharedPreferences.setMockInitialValues({});

    await _necessaryIntializations(); // Must be before rootWidget.

    // Creating app startup instance for initialization.
    const appStartup = AppStartup();
    final container_ = await appStartup.initializeProviderContainer();
    final root = await appStartup.createRootWidget(container: container ?? container_, minimumTest: true);

    // * Entry point of the app
    await tester.pumpWidget(root);
    await tester.pumpAndSettle();
  }
}
