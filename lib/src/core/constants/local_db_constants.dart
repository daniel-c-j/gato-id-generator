// coverage:ignore-file

// ignore_for_file: constant_identifier_names

// TODO delete those that are unnecessary
/// Data container containing local database keys.
final class DBKeys {
  // Hive-specific IDs
  // ! Warning these are IDs and should be UNIQUE.
  static const int AUTH_STATE_HIVE = 0;
  static const int BASE_USER_HIVE = 1;
  static const int LOCAL_USER_HIVE = 2;

  // Hive-specific box names
  static const String BRIGHTNESS_BOX = "BRIGHTNESS_BOX";
  static const String AUTH_STATE_BOX = "AUTH_STATE_BOX";
  static const String LOCAL_USER_BOX = "LOCAL_USER_BOX";

  // Key names
  static const String BRIGHTNESS_LIGHT = "BRIGHTNESS_LIGHT";
  static const String AUTH_STATE = "AUTH_STATE";
}
