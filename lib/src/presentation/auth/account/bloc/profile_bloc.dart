import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:gato_id_generator/src/domain/use_case/auth_usecase.dart';
import 'package:gato_id_generator/src/util/delay.dart';

import '../../../../data/model/app_user/app_user.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetCurrentUserUsecase _currentUserUsecase;
  final SignOutUsecase _signOutUsecase;

  ProfileBloc(this._currentUserUsecase, this._signOutUsecase) : super(ProfileIdle()) {
    on<ProfileSignOut>(_signOut);
  }

  Stream<AppUser?> getUser() => _currentUserUsecase.execute();

  Future<void> _signOut(ProfileSignOut event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    await delay(true);

    try {
      await _signOutUsecase.execute();
      event.onSuccess();
      emit(ProfileIdle());
    } catch (e, st) {
      event.onError(e, st);
      emit(ProfileError());
    }
  }
}
