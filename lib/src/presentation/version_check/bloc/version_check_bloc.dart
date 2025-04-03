import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../core/_core.dart';
import '../../../core/exceptions/_exceptions.dart';
import '../../../data/model/version_check.dart';
import '../../../domain/use_case/version_check_usecase.dart';

part 'version_check_event.dart';
part 'version_check_state.dart';

// TODO global bloc observer

class VersionCheckBloc extends Bloc<VersionCheckEvent, VersionCheckState> {
  VersionCheckBloc() : super(VersionCheckIdle()) {
    on<CheckVersionData>((event, emit) async => await _check(event, emit));
  }

  Future<void> _check(CheckVersionData event, Emitter<VersionCheckState> emit) async {
    late final VersionCheck versionCheck;
    emit(VersionCheckLoading());

    try {
      versionCheck = await getIt<VersionCheckUsecase>().execute();
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
    return onError(UpdateCheckException(), st);
  }

  @visibleForTesting
  void handleErrors(Object? error, StackTrace st,
          {required void Function(Object e, StackTrace? st) onError}) =>
      _handleErrors(error, st, onError: onError);
}
