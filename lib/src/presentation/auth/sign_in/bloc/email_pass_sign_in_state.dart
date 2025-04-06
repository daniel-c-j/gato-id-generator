part of 'email_pass_sign_in_bloc.dart';

@immutable
abstract class EmailPassSignInState {}

class EmailPassSignInIdle extends EmailPassSignInState {}

class EmailPassSignInLoading extends EmailPassSignInState {}

class EmailPassSignInError extends EmailPassSignInState {}
