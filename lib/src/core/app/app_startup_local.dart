import '../_core.dart';
// TODO

/// Extension methods specific for the "local" project configuration
extension AppStartupLocal on AppStartup {
  /// Setting up [GetIt] dependency injection at the top-level with local/fake
  /// repositories only. This is useful for testing purposes and for running the
  /// app with a "fake" backend.
  Future<void> runWithLocal() async {
    // getIt
  }
}
