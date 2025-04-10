import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gato_id_generator/src/data/repository/generate_id/remote_generate_id_repo.dart';
import 'package:gato_id_generator/src/domain/repository/auth_repo.dart';
import 'package:gato_id_generator/src/domain/repository/generate_id_repo.dart';
import 'package:go_router/go_router.dart';

import '../../data/repository/auth/remote_auth_repo.dart';
import '../_core.dart';
import '../routing/app_router.dart';

/// Extension methods specific for the "remote" project configuration
extension AppStartupRemote on AppStartup {
  /// Setting up [GetIt] dependency injection at the top-level with remote
  /// repositories only.
  ///
  /// [WARNING] This method must be called after initializeApp is called.
  Future<void> runWithRemote() async {
    // * Using singleton since it maintains one must-ready, globally-shared state.
    getIt.registerSingleton<AuthRepository>(RemoteAuthRepository(FirebaseAuth.instance));

    // Route
    // ! This is core, but must be after authRepo.
    getIt.registerSingleton<GoRouter>(goRouterInstance(getIt<AuthRepository>()));

    // Generate ID feature
    final firestore = FirebaseFirestore.instance;
    getIt.registerLazySingleton<GenerateIdRepo>(() => RemoteGenerateIdRepo(firestore, getIt<ApiService>()));
  }

  // TODO emulator
  Future<void> setupFirebaseEmulators() async {
    await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
    FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
    // * When running on the emulator, disable persistence to avoid discrepancies
    // * between the emulated database and local caches. More info here:
    // * https://firebase.google.com/docs/emulator-suite/connect_firestore#instrument_your_app_to_talk_to_the_emulators
    FirebaseFirestore.instance.settings = const Settings(persistenceEnabled: false);
  }
}
