// coverage:ignore-file
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gato_id_generator/src/domain/repository/auth_repo.dart';
import 'package:gato_id_generator/src/domain/repository/generate_id_repo.dart';
import 'package:gato_id_generator/src/domain/use_case/auth_usecase.dart';
import 'package:gato_id_generator/src/domain/use_case/generate_id_usecase.dart';
import 'package:gato_id_generator/src/presentation/auth/account/bloc/profile_bloc.dart';
import 'package:gato_id_generator/src/presentation/auth/account/view/profile_screen.dart';
import 'package:gato_id_generator/src/presentation/auth/sign_in/bloc/email_pass_sign_in_bloc.dart';
import 'package:gato_id_generator/src/presentation/auth/sign_in/view/sign_in_screen.dart';
import 'package:gato_id_generator/src/presentation/generate/bloc/generated_gato_id_bloc.dart';
import 'package:gato_id_generator/src/presentation/generate/bloc/image_load_cubit.dart';
import 'package:go_router/go_router.dart';

import '../../domain/repository/version_repo.dart';
import '../../domain/use_case/version_check_usecase.dart';
import '../../presentation/_common_widgets/hud_overlay.dart';
import '../../presentation/auth/sign_in/view/email_password_sign_in_form_type.dart';
import '../../presentation/generate/view/generate_screen.dart';
import '../../presentation/version_check/bloc/version_check_bloc.dart';
import '../../util/navigation.dart';
import '../../presentation/home/view/home_screen.dart';
import 'not_found_screen.dart';
import '../_core.dart';
import 'go_router_refresh_stream.dart';

/// Defined app route to be handful when managing route name.
enum AppRoute {
  home,
  signIn,
  profile,
  generate,
  about,
  license,
  unknown;

  const AppRoute();
  String get path => "/$name";
}

GoRouter goRouterInstance(AuthRepository authRepo) {
  return GoRouter(
    debugLogDiagnostics: !kReleaseMode,
    navigatorKey: NavigationService.navigatorKey,
    refreshListenable: GoRouterRefreshStream(authRepo.authStateChanges()),
    initialLocation: '/',
    redirect: (context, state) {
      final isLogin = authRepo.currentUser != null;
      final path = state.uri.path;

      if (isLogin) {
        // If logging in and in signIn, return back.
        if (path == AppRoute.signIn.path) return '/';
      } else {
        // If not logging in... force to go to signIn route.
        if (path.startsWith(AppRoute.generate.path)) return AppRoute.signIn.path;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        name: AppRoute.home.name,
        builder: (context, state) {
          final versionUseCase = VersionCheckUsecase(getIt<VersionCheckRepo>());
          final watchUserUseCase = WatchUserUsecase(authRepo);
          final currentUserUseCase = GetCurrentUserUsecase(authRepo);
          final signOutUseCase = SignOutUsecase(authRepo);

          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => ProfileBloc(watchUserUseCase, currentUserUseCase, signOutUseCase),
              ),
              BlocProvider(
                create: (context) => VersionCheckBloc(versionUseCase),
              )
            ],
            child: const HudOverlay(child: HomeScreen()),
          );
        },
        routes: [
          GoRoute(
            path: AppRoute.generate.path,
            name: AppRoute.generate.name,
            builder: (context, state) {
              final generateRepo = getIt<GenerateIdRepo>();
              final generateIdUseCase = GenerateIdUsecase(generateRepo, authRepo);
              final saveGenerateIdUsecase = SaveGenerateIdUsecase(generateRepo, authRepo);
              final deleteIdUsecase = DeleteIdUsecase(generateRepo, authRepo);
              final getGeneratedIdStatsUseCase = GetGenerateIdStatsUsecase(generateRepo, authRepo);

              return MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) => GeneratedGatoIdBloc(
                      generateIdUseCase,
                      saveGenerateIdUsecase,
                      deleteIdUsecase,
                      getGeneratedIdStatsUseCase,
                    ),
                  ),
                  BlocProvider(create: (context) => ImageIsLoadedCubit())
                ],
                child: const HudOverlay(child: GenerateScreen()),
              );
            },
            routes: [],
          ),
          GoRoute(
            path: AppRoute.signIn.path,
            name: AppRoute.signIn.name,
            builder: (context, state) {
              final createUserUsecase = CreateUserWithEmailPasswUsecase(authRepo);
              final signInUsecase = SignInWithEmailPasswUsecase(authRepo);

              return BlocProvider(
                create: (context) => EmailPassSignInBloc(createUserUsecase, signInUsecase),
                child: const HudOverlay(
                  child: EmailPasswordSignInScreen(
                    formType: EmailPasswordSignInFormType.signIn, // By default.
                  ),
                ),
              );
            },
          ),
          GoRoute(
            path: AppRoute.profile.path,
            name: AppRoute.profile.name,
            builder: (context, state) {
              final watchUserUseCase = WatchUserUsecase(authRepo);
              final currentUserUseCase = GetCurrentUserUsecase(authRepo);
              final signOutUseCase = SignOutUsecase(authRepo);

              final generateRepo = getIt<GenerateIdRepo>();
              final generateIdUseCase = GenerateIdUsecase(generateRepo, authRepo);
              final deleteIdUsecase = DeleteIdUsecase(generateRepo, authRepo);
              final saveGenerateIdUsecase = SaveGenerateIdUsecase(generateRepo, authRepo);
              final getGeneratedIdStatsUseCase = GetGenerateIdStatsUsecase(generateRepo, authRepo);

              return MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) => ProfileBloc(
                      watchUserUseCase,
                      currentUserUseCase,
                      signOutUseCase,
                    ),
                  ),
                  BlocProvider(
                    create: (context) => GeneratedGatoIdBloc(
                      generateIdUseCase,
                      saveGenerateIdUsecase,
                      deleteIdUsecase,
                      getGeneratedIdStatsUseCase,
                    ),
                  ),
                ],
                child: const HudOverlay(child: ProfileScreen()),
              );
            },
          ),
        ],
      ),
      GoRoute(
        path: AppRoute.about.path,
        name: AppRoute.about.name,
        builder: (context, state) {
          // TODO
          return const HudOverlay(child: SizedBox());
        },
        routes: [
          GoRoute(
            path: AppRoute.license.path,
            name: AppRoute.license.name,
            builder: (context, state) => const LicensePage(),
          ),
        ],
      ),
      GoRoute(
        path: "/404",
        name: AppRoute.unknown.name,
        builder: (context, state) => const NotFoundScreen(),
      ),
    ],
    errorBuilder: (context, state) => const NotFoundScreen(),
  );
}
