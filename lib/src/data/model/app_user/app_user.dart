import 'package:gato_id_generator/src/core/constants/_constants.dart';
import 'package:hive_ce/hive.dart';

part 'app_user.g.dart';

/// Simple class representing the user UID and email.
@HiveType(typeId: DBKeys.BASE_USER_HIVE)
class AppUser {
  const AppUser({
    required this.uid,
    this.email,
    // this.emailVerified = false,
  });

  @HiveField(0)
  final String uid;
  @HiveField(1)
  final String? email;

  // TODO check email verification
  // @HiveField(2)
  // final bool emailVerified;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AppUser && other.uid == uid && other.email == email;
  }

  @override
  int get hashCode => uid.hashCode ^ email.hashCode;

  @override
  String toString() => 'AppUser(uid: $uid, email: $email)';
}
