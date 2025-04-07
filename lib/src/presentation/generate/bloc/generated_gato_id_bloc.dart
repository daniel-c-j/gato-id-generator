import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:gato_id_generator/src/util/delay.dart';

part 'generated_gato_id_event.dart';
part 'generated_gato_id_state.dart';

class GeneratedGatoIdBloc extends Bloc<GeneratedGatoIdEvent, GeneratedGatoIdState> {
  GeneratedGatoIdBloc() : super(GeneratedGatoIdIdle()) {
    on<GenerateGatoId>(_generate);
  }

  Future<void> _generate(GenerateGatoId event, Emitter<GeneratedGatoIdState> emit) async {
    emit(GeneratedGatoIdLoading());
    await delay(true);

    try {
// Generate usecase => repo
      event.onSuccess();
      emit(GeneratedGatoIdIdle());
    } catch (e, st) {
      event.onError(e, st);
      emit(GeneratedGatoIdError());
    }
  }
}
