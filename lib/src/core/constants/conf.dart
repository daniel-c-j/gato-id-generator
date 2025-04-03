// coverage:ignore-file

// ignore_for_file: constant_identifier_names, non_constant_identifier_names

// TODO delete those that are unnecessary

/// Data container containing default app configurations.
final class Default {
  // Used for settings.
  static late final bool BRIGHTNESS_LIGHT;
  static late final bool AUTO_UPDATE_CHECK_CONF;
  static late final int CIPHER_ALGORITHM_INDEX;

  /// Lazy Initialization exists for the ease of testing to manipulate certain properties of [Default].
  static void init() {
    BRIGHTNESS_LIGHT = true; // false for dark mode.
    AUTO_UPDATE_CHECK_CONF = true;
    CIPHER_ALGORITHM_INDEX = 0;
  }
}
