// ignore_for_file: depend_on_referenced_packages

import 'dart:io';
import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gato_id_generator/src/core/local_db/hive_registrar.g.dart';
import 'package:gato_id_generator/src/presentation/_common_widgets/custom_appbar.dart';
import 'package:gato_id_generator/src/presentation/home/view/home_screen.dart';
import 'package:hive_ce/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gato_id_generator/src/core/constants/_constants.dart';
import 'package:gato_id_generator/src/core/_core.dart';

import 'goldens/golden_robot.dart';
import 'robots/auth_robot.dart';
import 'robots/generate_robot.dart';
import 'robots/home_robot.dart';

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

  Future<void> _necessaryIntializations(bool isIntegration) async {
    try {
      await EasyLocalization.ensureInitialized();
      Default.init();
      NetConsts.init();
      await AppInfo.init(const PackageInfoWrapper());

      // Hive-specific
      Hive.init((isIntegration)
          ? (await getTemporaryDirectory()).path
          : Directory("temp/${Random().nextInt(10000)}/").path);

      Hive.registerAdapters();
      await Hive.initBoxes();
    } catch (e) {
      if (kDebugMode) {
        print("ERROR");
        print(e);
      }
    }
  }

  Future<void> pumpApp({bool isIntegration = false}) async {
    TestWidgetsFlutterBinding.ensureInitialized();
    WidgetsFlutterBinding.ensureInitialized();

    // Simulation requirements.
    randomGatoCardPreview = false;
    canListenToNetworkStatusChange = false;

    // Easy_localization test requirement.
    SharedPreferences.setMockInitialValues({});

    // ! Must be before appStartup.
    await _necessaryIntializations(isIntegration);

    // Try to reset first.
    try {
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
      print("ERRRRRRROOOOOOOOOOORRRRRRRRRR");
      print(e);
    }

    // * Entry point of the app
    final root = await appStartup.createRootWidget();
    await tester.pumpWidget(root);
    await tester.pumpAndSettle();
  }

  Finder expectSnackBar() {
    final finder = find.byType(SnackBar);
    expect(finder, findsOneWidget);
    return finder;
  }

  Finder expectBackButton() {
    final finder = find.byType(BackIconButton);
    expect(finder, findsOneWidget);
    return finder;
  }

  Future<void> tapBackButton() async {
    await tester.tap(expectBackButton());
    await tester.pumpAndSettle();
  }
}
