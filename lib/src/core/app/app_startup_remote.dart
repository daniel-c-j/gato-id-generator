// coverage:ignore-file
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gato_id_generator/src/data/repository/auth/remote_supabase_auth_repo.dart';
import 'package:gato_id_generator/src/data/repository/generate_id/remote_firebase_generate_id_repo.dart';
import 'package:gato_id_generator/src/data/repository/generate_id/remote_supabase_generate_id_repo.dart';
import 'package:gato_id_generator/src/domain/repository/auth_repo.dart';
import 'package:gato_id_generator/src/domain/repository/generate_id_repo.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show Supabase;

import '../../../firebase_options.dart';
import '../../data/repository/auth/remote_firebase_auth_repo.dart';
import '../_core.dart';
import '../constants/_constants.dart';

enum RemoteBackendType {
  firebase,
  supabase,
}

/// Extension methods specific for the "remote" project configuration
extension AppStartupRemote on AppStartup {
  /// Setting up [GetIt] dependency injection at the top-level with remote
  /// repositories only.
  ///
  /// [WARNING] This method must be called after initializeApp is called.
  Future<void> runWithRemote(RemoteBackendType backendType) async {
    late final AuthRepository auth;
    late final GenerateIdRepo genIdRepo;

    if (backendType == RemoteBackendType.firebase) {
      // Initializing firebase.
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      auth = RemoteFirebaseAuthRepository(FirebaseAuth.instance);
      genIdRepo = RemoteFirebaseGenerateIdRepo(FirebaseFirestore.instance, getIt<ApiService>());
    } else {
      // Initializing supabase.
      await Supabase.initialize(
        url: NetConsts.SUPABASE_URL,
        anonKey: NetConsts.SUPABASE_ANONKEY,
      );

      final supabase = Supabase.instance.client;
      auth = RemoteSupabaseAuthRepository(supabase.auth);
      genIdRepo = RemoteSupabaseGenerateIdRepo(supabase, getIt<ApiService>());
    }

    // * Using singleton (not lazysingleton) since it maintains one must-ready, globally-shared state.
    getIt.registerSingleton<AuthRepository>(auth);

    // ! Route. This is core, but must be after authRepo.
    getIt.registerSingleton<GoRouter>(goRouterInstance(getIt<AuthRepository>()));

    // Generate ID feature
    getIt.registerLazySingleton<GenerateIdRepo>(() => genIdRepo);
  }

  Future<void> setupFirebaseEmulators() async {
    await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
    FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
    // * When running on the emulator, disable persistence to avoid discrepancies
    // * between the emulated database and local caches. More info here:
    // * https://firebase.google.com/docs/emulator-suite/connect_firestore#instrument_your_app_to_talk_to_the_emulators
    FirebaseFirestore.instance.settings = const Settings(persistenceEnabled: false);
  }
}
