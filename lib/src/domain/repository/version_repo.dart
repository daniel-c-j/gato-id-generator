// coverage:ignore-file
import '../../data/model/version_check.dart';

abstract class VersionCheckRepo {
  const VersionCheckRepo();
  Future<VersionCheck> getVersionCheck();
}
