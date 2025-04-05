import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../_core.dart';

@visibleForTesting
bool canListenToNetworkStatusChange = true;

/// You can use this cubit in a provider alongside another bloc/cubit where network request exists.
class ConnectivityCubit extends Cubit<bool> {
  StreamSubscription<InternetStatus>? _subscription;

  ConnectivityCubit() : super(false) {
    if (!canListenToNetworkStatusChange) return;

    final internetConnectionChecker = getIt<InternetConnection>();

    _subscription = internetConnectionChecker.onStatusChange.listen(
      // Updates state to true when the condition is true, vice-versa.
      (InternetStatus status) => emit(status == InternetStatus.connected),
      onError: (error) => emit(false),
    );
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

@immutable
abstract class ConnectivityEvent {}

class ConnectivityStatusChanged extends ConnectivityEvent {}
