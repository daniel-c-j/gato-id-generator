// coverage:ignore-file
import 'package:gato_id_generator/src/data/model/app_user/app_user.dart';

import '../repository/auth_repo.dart';

class CreateUserWithEmailPasswUsecase {
  const CreateUserWithEmailPasswUsecase(this._repository);
  final AuthRepository _repository;

  Future<void> execute(String email, String passw) async =>
      await _repository.createUserWithEmailAndPassword(email, passw);
}

class SignInWithEmailPasswUsecase {
  const SignInWithEmailPasswUsecase(this._repository);
  final AuthRepository _repository;

  Future<void> execute(String email, String passw) async =>
      await _repository.signInWithEmailAndPassword(email, passw);
}

class SignOutUsecase {
  const SignOutUsecase(this._repository);
  final AuthRepository _repository;

  Future<void> execute() async => await _repository.signOut();
}

class WatchUserUsecase {
  const WatchUserUsecase(this._repository);
  final AuthRepository _repository;

  Stream<AppUser?> execute() => _repository.authStateChanges();
}

class GetCurrentUserUsecase {
  const GetCurrentUserUsecase(this._repository);
  final AuthRepository _repository;

  AppUser? execute() => _repository.currentUser;
}
