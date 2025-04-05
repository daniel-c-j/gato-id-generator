import '../_core.dart';

// TODO

/// Extension methods specific for the "remote" project configuration
extension AppStartupRemote on AppStartup {
  /// Setting up [GetIt] dependency injection at the top-level with remote
  /// repositories only.
  Future<void> runWithRemote() async {
    // getIt
  }

  // Future<void> setupFirebaseEmulators() async {
  //   await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  //   FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
  //   await FirebaseStorage.instance.useStorageEmulator('localhost', 9199);
  //   // * When running on the emulator, disable persistence to avoid discrepancies
  //   // * between the emulated database and local caches. More info here:
  //   // * https://firebase.google.com/docs/emulator-suite/connect_firestore#instrument_your_app_to_talk_to_the_emulators
  //   FirebaseFirestore.instance.settings = const Settings(persistenceEnabled: false);
  // }
}
