// ignore_for_file: public_member_api_docs, sort_constructors_first
// coverage:ignore-file
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

import 'app_user.dart';

/// Wrapper for the [User] class inside the firebase_auth package
class RemoteFirebaseAppUser implements AppUser {
  const RemoteFirebaseAppUser(this._user);
  final firebase.User _user;

  @override
  String get uid => _user.uid;

  @override
  String? get email => _user.email;
}

/// Wrapper for the [User] class for supabase client package.
class RemoteSupabaseAppUser implements AppUser {
  const RemoteSupabaseAppUser(this._user);
  final supabase.User _user;

  @override
  String get uid => _user.id;

  @override
  String? get email => _user.email;
}
