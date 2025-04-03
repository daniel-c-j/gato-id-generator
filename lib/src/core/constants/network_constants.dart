// coverage:ignore-file

// ignore_for_file: non_constant_identifier_names, constant_identifier_names

/// Data container containing network constants.
final class NetConsts {
  /// [Dio] configuration.
  static const String APPLICATION_JSON = "application/json";
  static const String CONTENT_TYPE = "content-type";
  static const String AUTHORIZATION = "Authorization";
  static const String ACCEPT = "accept";
  static const int API_TIMEOUT = 60000;

  /// Used for [VersionCheck].
  static late final String URL_CHECK_VERSION;
  static late final String URL_UPDATE_VERSION;

  /// Lazy Initialization exists for the ease of testing to manipulate certain properties of [NetConsts].
  static void init() {
// TODO INSERT
    URL_CHECK_VERSION = "";
    URL_UPDATE_VERSION = "";
  }
}
