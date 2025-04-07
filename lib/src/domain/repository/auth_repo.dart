import '../../data/model/app_user/app_user.dart';

abstract class AuthRepository {
  Future<void> signInWithEmailAndPassword(String email, String password);

  Future<void> createUserWithEmailAndPassword(String email, String password);

  Future<void> signOut();

  Stream<AppUser?> authStateChanges();

  AppUser? get currentUser;

  // TODO deleteUser
  // Future<void> deleteUser();
}
