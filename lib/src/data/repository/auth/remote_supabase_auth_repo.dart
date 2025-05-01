import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../domain/repository/auth_repo.dart';
import '../../model/app_user/app_user.dart';
import '../../model/app_user/remote_app_user.dart';

class RemoteSupabaseAuthRepository implements AuthRepository {
  RemoteSupabaseAuthRepository(this._auth);
  final GoTrueClient _auth;

  @override
  Future<void> signInWithEmailAndPassword(String email, String password) {
    return _auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> createUserWithEmailAndPassword(String email, String password) {
    return _auth.signUp(
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
    return _auth.onAuthStateChange.map((state) {
      final rawUser = state.session?.user;

      if (rawUser == null) return null;
      return _convertUser(rawUser);
    });
  }

  @override
  AppUser? get currentUser => _convertUser(_auth.currentUser);

  /// Helper method to convert a [User] to an [AppUser]
  AppUser? _convertUser(User? user) => user != null ? RemoteSupabaseAppUser(user) : null;

  // TODO deleteUser
}
