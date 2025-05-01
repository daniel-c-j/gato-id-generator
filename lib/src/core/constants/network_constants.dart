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

  // Used for [VersionCheck].
  static late final String URL_CHECK_VERSION;
  static late final String URL_GET_UPDATED_VERSION;

  // Used for [GenerateIdRepo]
  static late final String URL_GATO_IMG;
  static late final String URL_SAVED_GATO_IMG_API;

// [Supabase] related
  static late final String SUPABASE_URL;
  static late final String SUPABASE_ANONKEY;

  /// Lazy Initialization exists for the ease of testing to manipulate certain properties of [NetConsts].
  static void init() {
    URL_CHECK_VERSION =
        "https://raw.githubusercontent.com/Daniel-C-J/gato-id-generator/refs/heads/master/VERSION.json";
    URL_GET_UPDATED_VERSION = "https://github.com/Daniel-C-J/gato-id-generator/releases";
    URL_GATO_IMG = "https://cataas.com/cat";
    URL_SAVED_GATO_IMG_API = "https://catbox.moe/user/api.php";

    // TODO insert your own supabase configuration, or just leave empty if you're not using
    // supabase.
    SUPABASE_URL = "";
    SUPABASE_ANONKEY = "";
  }
}
