// coverage:ignore-file

// ignore_for_file: constant_identifier_names

// TODO delete those that are unnecessary
/// Data container containing local database keys.
final class DBKeys {
  // Hive-specific IDs
  // ! Warning these are IDs and should be UNIQUE.
  static const int CIPHER_ACTION_HIVE = 0;
  static const int CIPHER_ALROGITHM_TYPE_HIVE = 1;
  static const int CIPHER_ALROGITHM_HIVE = 2;

  // Hive-specific box names
  static const String BRIGHTNESS_BOX = "BRIGHTNESS_BOX";
  static const String CIPHER_REPO_BOX = "CIPHER_REPO_BOX";

  // Key names
  static const String BRIGHTNESS_LIGHT = "BRIGHTNESS_LIGHT";
  static const String CIPHER_ALGORITHM_INDEX = "CIPHER_ALGORITHM_INDEX";
}
