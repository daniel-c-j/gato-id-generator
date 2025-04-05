// coverage:ignore-file
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../domain/repository/version_repo.dart';
import '../../domain/use_case/version_check_usecase.dart';
import '../../presentation/common_widgets/hud_overlay.dart';
import '../../presentation/generate/view/generate_screen.dart';
import '../../presentation/version_check/bloc/version_check_bloc.dart';
import '../../util/navigation.dart';
import '../../presentation/home/view/home_screen.dart';
import '../../presentation/common_widgets/not_found_screen.dart';
import '../_core.dart';
import 'go_router_refresh_stream.dart';

/// Defined app route to be handful when managing route name.
enum AppRoute {
  home,
  generate,
  about,
  license,
  unknown;

  const AppRoute();
}

extension AppRouteExtension on AppRoute {
  String get path => "/$name";
}

GoRouter get goRouterInstance => GoRouter(
      debugLogDiagnostics: !kReleaseMode,
      navigatorKey: NavigationService.navigatorKey,
      // TODO
      // refreshListenable: GoRouterRefreshStream(),
      initialLocation: '/',
      redirect: (context, state) {
        // Placeholder
        return;
      },
      routes: [
        GoRoute(
          path: '/',
          name: AppRoute.home.name,
          builder: (context, state) {
            final versionUseCase = VersionCheckUsecase(getIt<VersionCheckRepo>());

            return BlocProvider(
              create: (context) => VersionCheckBloc(versionUseCase),
              child: const HudOverlay(child: HomeScreen()),
            );
          },
          routes: [],
          onExit: (context, state) {
            // Prevent keyboard suddenly opens when going back to home screen after
            // once focused on one of the textfields.
            FocusScope.of(context).unfocus();
            return true;
          },
        ),
        GoRoute(
          path: AppRoute.generate.path,
          name: AppRoute.generate.name,
          builder: (context, state) {
            // TODO
            final versionUseCase = VersionCheckUsecase(getIt<VersionCheckRepo>());

            return BlocProvider(
              create: (context) => VersionCheckBloc(versionUseCase),
              child: const HudOverlay(child: GenerateScreen()),
            );
          },
          routes: [],
        ),
        GoRoute(
          path: AppRoute.about.path,
          name: AppRoute.about.name,
          builder: (context, state) {
            return const HudOverlay(child: SizedBox());
          },
          routes: [
            GoRoute(
              path: AppRoute.license.path,
              name: AppRoute.license.name,
              builder: (context, state) {
                return const LicensePage();
              },
            ),
          ],
        ),
        GoRoute(
          path: "/404",
          name: AppRoute.unknown.name,
          builder: (context, state) {
            return const NotFoundScreen();
          },
        ),
      ],
      errorBuilder: (context, state) {
        return const NotFoundScreen();
      },
    );
