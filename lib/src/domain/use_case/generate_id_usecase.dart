import 'package:gato_id_generator/src/data/model/gato_id.dart';
import 'package:gato_id_generator/src/data/repository/generate_repo.dart';

class GenerateIdUsecase {
  const GenerateIdUsecase(this._repository);
  final GenerateIdRepo _repository;

  Future<GatoId> execute() async => await _repository.generate();
}
