import 'package:gato_id_generator/src/core/constants/_constants.dart';
import 'package:gato_id_generator/src/data/model/app_user/local_app_user.dart';
import 'package:gato_id_generator/src/data/repository/auth/local_auth_repo.dart';
import 'package:gato_id_generator/src/data/repository/generate_id/local_generate_id_repo.dart';
import 'package:gato_id_generator/src/domain/repository/generate_id_repo.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_ce/hive.dart';

import '../../domain/repository/auth_repo.dart';
import '../_core.dart';
import '../routing/app_router.dart';
// TODO

/// Extension methods specific for the "local" project configuration
extension AppStartupLocal on AppStartup {
  /// Setting up [GetIt] dependency injection at the top-level with local/fake
  /// repositories only. This is useful for testing purposes and for running the
  /// app with a "fake" backend.
  ///
  /// [WARNING] This method should be called after initializeApp is called.
  Future<void> runWithLocal() async {
    // * Using singleton since it maintains one must-ready, globally-shared state.
    final dataSource = Hive.box<LocalAppUser>(DBKeys.USER_BOX);
    getIt.registerSingleton<AuthRepository>(LocalAuthRepository(dataSource));

    // Route
    // ! Must be after authRepo
    getIt.registerSingleton<GoRouter>(goRouterInstance(getIt<AuthRepository>()));

    // Generate ID feature
    final savedId = Hive.box<String>(DBKeys.SAVED_ID_BOX);
    final generatedId = Hive.box<int>(DBKeys.GENERATED_ID_COUNT_BOX);
    getIt.registerLazySingleton<GenerateIdRepo>(() => LocalGenerateIdRepo(savedId, generatedId));
  }
}
