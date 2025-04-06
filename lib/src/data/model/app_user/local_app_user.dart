import 'app_user.dart';

/// Local user class used to simulate a user account on the backend.
class LocalAppUser extends AppUser {
  const LocalAppUser({
    required super.uid,
    required super.email,
    required this.password,
  });
  final String password;
}
