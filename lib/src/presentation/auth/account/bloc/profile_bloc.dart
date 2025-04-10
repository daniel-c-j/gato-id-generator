import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:gato_id_generator/src/domain/use_case/auth_usecase.dart';

import '../../../../data/model/app_user/app_user.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final WatchUserUsecase _watchUserUsecase;
  final GetCurrentUserUsecase _getCurrentUserUsecase;
  final SignOutUsecase _signOutUsecase;

  ProfileBloc(this._watchUserUsecase, this._getCurrentUserUsecase, this._signOutUsecase)
      : super(ProfileIdle()) {
    on<ProfileSignOut>(_signOut);
  }

  /// Watches state of user, indirectly also the authentication state.
  Stream<AppUser?> watchUser() => _watchUserUsecase.execute();
  AppUser? getUser() => _getCurrentUserUsecase.execute();

  Future<void> _signOut(ProfileSignOut event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());

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
