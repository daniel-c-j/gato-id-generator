import 'app_user.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Wrapper for the [User] class inside the firebase_auth package
class RemoteAppUser implements AppUser {
  const RemoteAppUser(this._user);
  final User _user;

  @override
  String get uid => _user.uid;

  @override
  String? get email => _user.email;
}
