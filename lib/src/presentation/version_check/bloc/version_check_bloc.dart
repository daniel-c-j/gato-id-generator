import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:gato_id_generator/src/domain/repository/version_repo.dart';

import '../../../core/_core.dart';
import '../../../core/exceptions/_exceptions.dart';
import '../../../data/model/version_check.dart';
import '../../../domain/use_case/version_check_usecase.dart';

part 'version_check_event.dart';
part 'version_check_state.dart';

class VersionCheckBloc extends Bloc<VersionCheckEvent, VersionCheckState> {
  final VersionCheckUsecase _versionCheckUsecase;

  VersionCheckBloc(this._versionCheckUsecase) : super(VersionCheckIdle()) {
    on<CheckVersionData>(_check);
  }

  @override
  Future<void> close() async {
    if (getIt.isRegistered<VersionCheckRepo>()) getIt.unregister<VersionCheckRepo>();
    return super.close();
  }

  /// Will execute [VersionCheckUsecase] to fetch and check the data in the repository.
  Future<void> _check(CheckVersionData event, Emitter<VersionCheckState> emit) async {
    late final VersionCheck versionCheck;
    emit(VersionCheckLoading());

    try {
      versionCheck = await _versionCheckUsecase.execute();
      emit(VersionCheckIdle());

      // Typically calls for a showDialog widget.
      return event.onSuccess(versionCheck);
    } catch (e, st) {
      // Throws custom exception.
      emit(VersionCheckIdle());
      return _handleErrors(e, st, onError: event.onError);
    }
  }

  void _handleErrors(
    Object? error,
    StackTrace st, {
    required void Function(AppException e, StackTrace? st) onError,
  }) {
    if (error is DioException) {
      final netError = getIt<NetworkErrorHandlerService>().handle(error);
      return onError(netError, st);
    }

    // Doesn't care what kind of exception, just return the formatted one.
    return onError(const UpdateCheckException(), st);
  }

  @visibleForTesting
  void handleErrors(Object? error, StackTrace st,
          {required void Function(Object e, StackTrace? st) onError}) =>
      _handleErrors(error, st, onError: onError);
}
