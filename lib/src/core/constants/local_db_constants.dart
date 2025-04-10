// coverage:ignore-file
// ignore_for_file: constant_identifier_names

/// Data container containing local database keys.
final class DBKeys {
  // Hive-specific IDs
  // ! Warning these are IDs and should be UNIQUE.
  static const int AUTH_STATE_HIVE = 0;
  static const int BASE_USER_HIVE = 1;
  static const int LOCAL_USER_HIVE = 2; // Implementation of BASE_USER_HIVE

  // Hive-specific box names
  static const String BRIGHTNESS_BOX = "BRIGHTNESS_BOX";
  static const String AUTH_STATE_BOX = "AUTH_STATE_BOX";
  static const String USER_BOX = "USER_BOX";
  static const String USERNAME_BOX = "USERNAME_BOX";
  static const String GENERATED_ID_COUNT_BOX = "GENERATED_ID_COUNT_BOX";
  static const String SAVED_ID_BOX = "SAVED_ID_BOX";

  // Unique Key names
  static const String BRIGHTNESS_LIGHT = "BRIGHTNESS_LIGHT";
  static const String AUTH_STATE = "AUTH_STATE";
  static const String USERNAME = "USERNAME";
  static const String GENERATED_ID_COUNT = "GENERATED_ID_COUNT";
}
