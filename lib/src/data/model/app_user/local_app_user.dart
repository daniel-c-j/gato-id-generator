import 'package:hive_ce/hive.dart';

import '../../../core/constants/_constants.dart';
import 'app_user.dart';

part 'local_app_user.g.dart';

/// Local user class used to simulate a user account on the backend.
@HiveType(typeId: DBKeys.LOCAL_USER_HIVE)
class LocalAppUser extends AppUser {
  const LocalAppUser({
    required super.uid,
    required super.email,
    required this.password,
  });
  // * index start from 2, so that it won't conflict with the parent class properties.
  @HiveField(2)
  final String password;
}
