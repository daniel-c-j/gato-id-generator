import 'package:gato_id_generator/src/core/_core.dart';
import 'package:gato_id_generator/src/core/routing/app_router.dart';
import 'package:gato_id_generator/src/core/theme/platform_brightness_bloc/platform_brightness_bloc.dart';
import 'package:gato_id_generator/src/data/repository/remote_version_repo.dart';
import 'package:gato_id_generator/src/domain/repository/version_repo.dart';
import 'package:gato_id_generator/src/domain/use_case/version_check_usecase.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../exceptions/_exceptions.dart';

final getIt = GetIt.instance;

Future<void> initAppModule() async {
  // Error Handlers
  getIt.registerLazySingleton<ErrorLogger>(() => ErrorLogger());
  getIt.registerLazySingleton<NetworkErrorHandlerService>(() => const NetworkErrorHandlerService());

  // ApiService
  final dio = DioFactory().getDio();
  getIt.registerSingleton<InternetConnection>(InternetConnection());
  getIt.registerLazySingleton<ApiService>(() => ApiService(dio, getIt<InternetConnection>()));

  // Route
  getIt.registerSingleton<GoRouter>(goRouterInstance);

  // Theme
  getIt.registerSingleton<AppTheme>(const AppTheme());
  getIt.registerSingleton<PlatformBrightnessBloc>(PlatformBrightnessBloc());

  // VersionCheck feature
  getIt.registerLazySingleton<VersionCheckRepo>(() => RemoteVersionCheckRepo(getIt<ApiService>()));
  getIt.registerLazySingleton<VersionCheckUsecase>(() => VersionCheckUsecase(getIt<VersionCheckRepo>()));
}
