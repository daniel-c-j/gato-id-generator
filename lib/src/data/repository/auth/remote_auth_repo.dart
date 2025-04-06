import 'package:firebase_auth/firebase_auth.dart';

import '../../../domain/repository/auth_repo.dart';
import '../../model/app_user/app_user.dart';
import '../../model/app_user/remote_app_user.dart';

class RemoteAuthRepository implements AuthRepository {
  RemoteAuthRepository(this._auth);
  final FirebaseAuth _auth;

  @override
  Future<void> signInWithEmailAndPassword(String email, String password) {
    return _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> createUserWithEmailAndPassword(String email, String password) {
    return _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> signOut() {
    return _auth.signOut();
  }

  /// Notifies about changes to the user's sign-in state (such as sign-in or
  /// sign-out).
  @override
  Stream<AppUser?> authStateChanges() {
    return _auth.authStateChanges().map(_convertUser);
  }

  @override
  AppUser? get currentUser => _convertUser(_auth.currentUser);

  /// Helper method to convert a [User] to an [AppUser]
  AppUser? _convertUser(User? user) => user != null ? RemoteAppUser(user) : null;
}
