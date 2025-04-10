import 'dart:typed_data';

import 'package:gato_id_generator/src/data/model/gato_id_content.dart';
import 'package:gato_id_generator/src/data/model/gato_id_stat.dart';
import 'package:gato_id_generator/src/domain/repository/auth_repo.dart';
import 'package:gato_id_generator/src/domain/repository/generate_id_repo.dart';

class GenerateIdUsecase {
  const GenerateIdUsecase(this._generateIdrepository, this._authRepo);
  final GenerateIdRepo _generateIdrepository;
  final AuthRepository _authRepo;

  Future<GatoId> execute() async {
    final gatoId = _generateIdrepository.generate();
    await _generateIdrepository.incrementAndSaveStats(uid: _authRepo.currentUser!.uid);
    return gatoId;
  }
}

class SaveGenerateIdUsecase {
  const SaveGenerateIdUsecase(this._generateIdrepository, this._authRepo);
  final GenerateIdRepo _generateIdrepository;
  final AuthRepository _authRepo;

  Future<void> execute(GatoId gatoId, Uint8List value) async {
    await _generateIdrepository.saveGenerated(gatoId.uid, value, uid: _authRepo.currentUser!.uid);
  }
}

class DeleteIdUsecase {
  const DeleteIdUsecase(this._generateIdrepository, this._authRepo);
  final GenerateIdRepo _generateIdrepository;
  final AuthRepository _authRepo;

  Future<void> execute(String uuid) async {
    await _generateIdrepository.delete(uid: _authRepo.currentUser!.uid, uuid: uuid);
  }
}

class GetGenerateIdStatsUsecase {
  const GetGenerateIdStatsUsecase(this._generateIdrepository, this._authRepo);
  final GenerateIdRepo _generateIdrepository;
  final AuthRepository _authRepo;

  Future<GatoIdStat> execute() async {
    return _generateIdrepository.getLatestStats(uid: _authRepo.currentUser!.uid);
  }
}
