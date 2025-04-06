import 'package:gato_id_generator/src/core/constants/_constants.dart';
import 'package:gato_id_generator/src/core/exceptions/_exceptions.dart';
import 'package:gato_id_generator/src/data/model/app_user/app_user.dart';
import 'package:gato_id_generator/src/data/model/app_user/local_app_user.dart';
import 'package:gato_id_generator/src/domain/repository/auth_repo.dart';
import 'package:hive_ce/hive.dart';

class LocalAuthRepository implements AuthRepository {
  LocalAuthRepository(this._dataSource);

  final Box<LocalAppUser?> _dataSource;
  final _authState = Hive.box<AppUser?>(DBKeys.AUTH_STATE_BOX);

  @override
  Stream<AppUser?> authStateChanges() => _authState.watch(key: DBKeys.AUTH_STATE).map((event) {
        return event.value;
      });

  @override
  AppUser? get currentUser {
    if (!_authState.isOpen) throw const DataBaseClosedException();
    return _authState.get(DBKeys.AUTH_STATE);
  }

  void dispose() => _authState.close();

  @override
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    if (!_dataSource.isOpen) throw const DataBaseClosedException();

    final users = _dataSource.values;

    // Updates the auth state.
    for (LocalAppUser? user in users) {
      if (email == user?.email && password == user?.password) {
        return _authState.put(DBKeys.AUTH_STATE, user);
      }
    }

    throw const WrongCredentialsException();
  }

  @override
  Future<void> createUserWithEmailAndPassword(String email, String password) async {
    if (!_dataSource.isOpen) throw const DataBaseClosedException();

    final users = _dataSource.keys;
    if (users.contains(email)) throw const EmailAlreadyInUseException();

    return await _dataSource.putAll({
      email: LocalAppUser(
        uid: email.split('').reversed.join(),
        email: email,
        password: password,
      ),
    });
  }

  @override
  Future<void> signOut() {
    if (!_authState.isOpen) throw const DataBaseClosedException();
    return _authState.put(DBKeys.AUTH_STATE, null);
  }
}
