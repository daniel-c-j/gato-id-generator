import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gato_id_generator/src/core/theme/platform_brightness_bloc/platform_brightness_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:go_transitions/go_transitions.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore:depend_on_referenced_packages
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:hive_ce/hive.dart';
import 'package:path_provider/path_provider.dart';
import '../../app.dart';
import '../constants/_constants.dart';
import '../exceptions/error_logger.dart';
import '../../util/context_shortcut.dart';
import '../_core.dart';

/// Helper class to initialize services and configure the error handlers.
class AppStartup {
  const AppStartup();

  /// Create the root widget that should be passed to [runApp].
  Future<Widget> createRootWidget({bool minimumTest = false}) async {
    // * Initalize app.
    if (!minimumTest) await _initializeApp();
    await initAppModule(); // Must be before initializeApp
    await _initializeAdditionalConf();

    // * Register error handlers.
    if (!minimumTest) _registerErrorHandlers();

    return EasyLocalization(
      path: 'assets/translations', // TODO localize strings in the app, watchout.
      supportedLocales: const [Locale('en', 'US')],
      fallbackLocale: const Locale('en', 'US'),
      child: App(),
    );
  }

  /// Core app initializations.
  Future<void> _initializeApp() async {
    // Localization initialization.
    await EasyLocalization.ensureInitialized();

    // Setting and getting general informations and configurations.
    Default.init();
    NetConsts.init();
    await AppInfo.init(const PackageInfoWrapper());

    // Hive localDB -- Must be after Default.init()
    if (!kIsWeb) Hive.init((await getApplicationDocumentsDirectory()).path);
    Hive.registerAdapters();
    await Hive.initBoxes();

    // Removing the # sign, and follow the real configured route in the URL for the web.
    if (kIsWeb) {
      usePathUrlStrategy();
      GoRouter.optionURLReflectsImperativeAPIs = true;
    }

    /// Set default transition values for all `GoTransition`.
    GoTransition.defaultCurve = Curves.easeInOut;
    GoTransition.defaultDuration = const Duration(milliseconds: 600);

    // Necessary to prevent http error for some devices.
    HttpOverrides.global = MyHttpOverrides();

    // Prevent google font to access internet to download the already downloaded font.
    GoogleFonts.config.allowRuntimeFetching = false;

    // Release mode configurations.
    if (kReleaseMode) {
      debugPrint = (String? message, {int? wrapWidth}) {};
      EasyLocalization.logger.enableBuildModes = [];
    }
  }

  /// Additional configurations.
  Future<void> _initializeAdditionalConf() async {
    await getIt<PlatformBrightnessBloc>().init();
  }

  /// Register Flutter error handlers.
  void _registerErrorHandlers() {
    final errorLogger = getIt<ErrorLogger>();

    // * Show some error UI if any uncaught exception happens
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      errorLogger.logError(details.exception, details.stack);
      if (kReleaseMode) exit(1);
    };

    // * Handle errors from the underlying platform/OS
    PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
      errorLogger.logError(error, stack);
      if (kReleaseMode) exit(1);
      return true;
    };

    // * Show some error UI when any widget in the app fails to build
    ErrorWidget.builder = (FlutterErrorDetails details) {
      return SizedBox(
        height: kScreenHeight(),
        width: kScreenWidth(),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.red,
            title: const Text('An error occurred'),
          ),
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Oops! Something went wrong.',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  GAP_H24,
                  Text(details.toString()),
                  GAP_H24,
                ],
              ),
            ),
          ),
        ),
      );
    };
  }

  @visibleForTesting
  void registerErrorHandlers() => _registerErrorHandlers();
}
