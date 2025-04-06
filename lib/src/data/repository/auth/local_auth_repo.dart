import 'package:gato_id_generator/src/core/constants/_constants.dart';
import 'package:gato_id_generator/src/data/model/app_user/app_user.dart';
import 'package:gato_id_generator/src/data/model/app_user/local_app_user.dart';
import 'package:gato_id_generator/src/domain/repository/auth_repo.dart';
import 'package:hive_ce/hive.dart';

class LocalAuthRepo implements AuthRepository {
  LocalAuthRepo(this._dataSource);

  final Box<LocalAppUser?> _dataSource;
  final _authState = Hive.box<AppUser?>(DBKeys.AUTH_STATE_BOX);

  @override
  Stream<AppUser?> authStateChanges() => _authState.watch(key: DBKeys.AUTH_STATE).map((event) {
        return event.value;
      });

  @override
  AppUser? get currentUser => _authState.get(DBKeys.AUTH_STATE);

  void dispose() => _authState.close();

  @override
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    if (!_dataSource.isOpen) throw Exception(); // Custom one.

    final user = _dataSource.get(DBKeys.USER);
    if (email == user?.email && password == user?.password) {
      return _authState.put(DBKeys.AUTH_STATE, user);
    }

    throw Exception(); // user not found
  }

  @override
  Future<void> createUserWithEmailAndPassword(String email, String password) async {
    if (!_dataSource.isOpen) throw Exception(); // Custom one.
    return await _dataSource.put(
      DBKeys.USER,
      LocalAppUser(
        uid: email.split('').reversed.join(),
        email: email,
        password: password,
      ),
    );
  }

  @override
  Future<void> signOut() {
    return _authState.put(DBKeys.AUTH_STATE, null);
  }
}
