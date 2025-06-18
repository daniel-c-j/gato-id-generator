// coverage:ignore-file
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:go_transitions/go_transitions.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore:depend_on_referenced_packages
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:hive_ce/hive.dart';
import 'package:path_provider/path_provider.dart';
import '/src/core/local_db/hive_registrar.g.dart';
import '../../app.dart';
import '../constants/_constants.dart';
import '../exceptions/_exceptions.dart';
import '../../util/context_shortcut.dart';
import '../_core.dart';

/// Helper class to initialize services and configure the error handlers.
class AppStartup {
  const AppStartup();

  /// Core app initializations.
  Future<void> initializeApp({bool minimumTest = false}) async {
    // * Initalize app.
    if (!minimumTest) await _initializeCores();

    // * Core GetIt initializations.
    await initCoreAppModule();

    // * Register error handlers.
    final errorLogger = getIt<ErrorLogger>();
    if (!minimumTest) _registerErrorHandlers(errorLogger);
  }

  /// Create the root widget that should be passed to [runApp].
  Future<Widget> createRootWidget() async {
    return EasyLocalization(
      path: 'assets/translations',
      supportedLocales: const [Locale('en', 'US')],
      fallbackLocale: const Locale('en', 'US'),
      child: const App(),
    );
  }

  /// Core app initializations.
  Future<void> _initializeCores() async {
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

    /// Set default transition values for all `GoTransition`.
    GoTransition.defaultCurve = Curves.easeInOut;
    GoTransition.defaultDuration = const Duration(milliseconds: 600);

    // Necessary to prevent http error for some devices.
    HttpOverrides.global = MyHttpOverrides();

    // Prevent google font to access internet to download the already downloaded font.
    GoogleFonts.config.allowRuntimeFetching = false;

    // Removing the # sign, and follow the real configured route in the URL for the web.
    if (kIsWeb) {
      usePathUrlStrategy();
      GoRouter.optionURLReflectsImperativeAPIs = true;
    }

    // Release mode configurations.
    if (kReleaseMode) {
      debugPrint = (String? message, {int? wrapWidth}) {};
      EasyLocalization.logger.enableBuildModes = [];
    }
  }

  /// Register Flutter error handlers.
  void _registerErrorHandlers(ErrorLogger errorLogger) {
    // * Bloc specific error handler.
    Bloc.observer = AppBlocObserver(errorLogger);

    // * Show some error UI if any uncaught exception happens
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      errorLogger.log(details.exception, details.stack);
    };

    // * Handle errors from the underlying platform/OS
    PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
      errorLogger.log(error, stack);
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
            padding: const EdgeInsets.all(8),
            child: Center(
              child: Text(details.toString()),
            ),
          ),
        ),
      );
    };
  }

  @visibleForTesting
  void registerErrorHandlers(ErrorLogger errorLogger) => _registerErrorHandlers(errorLogger);
}
