// coverage:ignore-file

// ignore_for_file: non_constant_identifier_names, constant_identifier_names

/// Data container containing network constants.
final class NetConsts {
  // [Dio] configuration.
  static const String APPLICATION_JSON = "application/json";
  static const String CONTENT_TYPE = "content-type";
  static const String AUTHORIZATION = "Authorization";
  static const String ACCEPT = "accept";
  static const int API_TIMEOUT = 60000;

  /// Used for [VersionCheck].
  static late final String URL_CHECK_VERSION;
  static late final String URL_GET_UPDATED_VERSION;

  // Generate ID image
  static late final String URL_GATO_IMG;
  static late final String URL_SAVED_GATO_IMG_API;

  /// Lazy Initialization exists for the ease of testing to manipulate certain properties of [NetConsts].
  static void init() {
    URL_CHECK_VERSION = "";
    URL_GET_UPDATED_VERSION = "";
    URL_GATO_IMG = "https://cataas.com/cat";
    URL_SAVED_GATO_IMG_API = "https://catbox.moe/user/api.php";
  }
}
