// coverage:ignore-file
import '../../data/model/version_check.dart';
import '../repository/version_repo.dart';

class VersionCheckUsecase {
  const VersionCheckUsecase(this._repository);
  final VersionCheckRepo _repository;

  Future<VersionCheck> execute() async => await _repository.getVersionCheck();
}
