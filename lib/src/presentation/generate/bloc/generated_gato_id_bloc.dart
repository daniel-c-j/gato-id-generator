import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:gato_id_generator/src/data/model/gato_id_stat.dart';
import 'package:gato_id_generator/src/domain/use_case/generate_id_usecase.dart';
import 'package:gato_id_generator/src/util/delay.dart';

import '../../../data/model/gato_id_content.dart';

part 'generated_gato_id_event.dart';
part 'generated_gato_id_state.dart';

class GeneratedGatoIdBloc extends Bloc<GeneratedGatoIdEvent, GeneratedGatoIdState> {
  final GenerateIdUsecase _generateIdUsecase;
  final SaveGenerateIdUsecase _saveGenerateIdUsecase;
  final DeleteIdUsecase _deleteIdUsecase;
  final GetGenerateIdStatsUsecase _getGenerateIdStatsUsecase;

  GeneratedGatoIdBloc(
    this._generateIdUsecase,
    this._saveGenerateIdUsecase,
    this._deleteIdUsecase,
    this._getGenerateIdStatsUsecase,
  ) : super(GeneratedGatoIdIdle()) {
    on<GenerateGatoId>(_generate);
    on<SaveGeneratedGatoId>(_save);
    on<DeleteGeneratedGatoId>(_delete);
  }

  GatoId? _gatoId;
  GatoId? get currentGatoId => _gatoId;
  Future<GatoIdStat> get latestStat => _getGenerateIdStatsUsecase.execute();

  Future<void> _generate(GenerateGatoId event, Emitter<GeneratedGatoIdState> emit) async {
    emit(GeneratedGatoIdLoading());
    // Delaying so that loading indicator exists, even if just for a moment.
    await delay(true, 300);

    try {
      _gatoId = await _generateIdUsecase.execute();
      event.onSuccess();

      emit(GeneratedGatoIdIdle());
    } catch (e, st) {
      event.onError(e, st);
      emit(GeneratedGatoIdError());
    }
  }

  Future<void> _save(SaveGeneratedGatoId event, Emitter<GeneratedGatoIdState> emit) async {
    emit(GeneratedGatoIdSaving());

    try {
      await _saveGenerateIdUsecase.execute(currentGatoId!, event.value);
      event.onSuccess();

      emit(GeneratedGatoIdIdle());
    } catch (e, st) {
      event.onError(e, st);
      emit(GeneratedGatoIdError());
    }
  }

  Future<void> _delete(DeleteGeneratedGatoId event, Emitter<GeneratedGatoIdState> emit) async {
    emit(GeneratedGatoIdDeleting());

    try {
      await _deleteIdUsecase.execute(event.id);
      event.onSuccess();

      emit(GeneratedGatoIdIdle());
    } catch (e, st) {
      event.onError(e, st);
      emit(GeneratedGatoIdError());
    }
  }
}
