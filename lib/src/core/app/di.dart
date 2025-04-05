import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../../data/repository/remote_version_repo.dart';
import '../../domain/repository/version_repo.dart';
import '../../presentation/common_widgets/hud_overlay.dart';
import '../_core.dart';
import '../exceptions/_exceptions.dart';
import '../routing/app_router.dart';

final getIt = GetIt.instance;

// TODO watchout disposing them.
Future<void> initCoreAppModule() async {
  // Error Handlers
  getIt.registerLazySingleton<ErrorLogger>(() => ErrorLogger());
  getIt.registerLazySingleton<NetworkErrorHandlerService>(() => const NetworkErrorHandlerService());

  // ApiService
  final dio = DioFactory().getDio();
  getIt.registerLazySingleton<InternetConnection>(() => InternetConnection());
  getIt.registerLazySingleton<ApiService>(() => ApiService(dio, getIt<InternetConnection>()));

  // Route
  getIt.registerSingleton<GoRouter>(goRouterInstance);

  // Theme
  getIt.registerSingletonAsync<PlatformBrightnessBloc>(() async {
    final brightness = PlatformBrightnessBloc();
    await brightness.init();
    return brightness;
  });

  // HUD feature
  getIt.registerLazySingleton<HudControllerCubit>(() => HudControllerCubit());

  // VersionCheck feature
  getIt.registerFactory<VersionCheckRepo>(() => RemoteVersionCheckRepo(getIt<ApiService>()));
}
