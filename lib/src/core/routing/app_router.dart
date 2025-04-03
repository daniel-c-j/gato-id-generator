// coverage:ignore-file
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/common_widgets/hud_overlay.dart';
import '../_core.dart';
import '../../presentation/home/view/home_screen.dart';
import '../../presentation/common_widgets/not_found_screen.dart';

/// Defined app route to be handful when managing route name.
enum AppRoute {
  home,
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
            return const HudOverlay(child: HomeScreen());
          },
          routes: [],
        ),
        GoRoute(
          path: AppRoute.about.path,
          name: AppRoute.about.name,
          builder: (context, state) {
            return const HudOverlay(child: SizedBox());
          },
          onExit: (context, state) {
            // Prevent keyboard suddenly opens when going back to home screen after
            // once focused on one of the textfields.
            FocusScope.of(context).unfocus();
            return true;
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
