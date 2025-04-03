import 'package:gato_id_generator/src/data/model/version_check.dart';
import 'package:gato_id_generator/src/domain/repository/version_repo.dart';

// TODO use case is just like APPLICATION/SRERVICE class where it depends on two or more repo. This time below
// is an exception just to show how it works.
class VersionCheckUsecase {
  const VersionCheckUsecase(this._repository);
  final VersionCheckRepo _repository;

  Future<VersionCheck> execute() async => await _repository.getVersionCheck();
}
