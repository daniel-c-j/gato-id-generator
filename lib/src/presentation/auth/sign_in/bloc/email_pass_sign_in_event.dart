part of 'email_pass_sign_in_bloc.dart';

@immutable
abstract class EmailPassSignInEvent {}

class EmailPassSignInSubmit implements EmailPassSignInEvent {
  EmailPassSignInSubmit({
    required this.email,
    required this.passw,
    required this.formType,
    required this.onSuccess,
    required this.onError,
  });

  final String email;
  final String passw;
  final EmailPasswordSignInFormType formType;
  final VoidCallback onSuccess;
  final void Function(Object? e, StackTrace st) onError;
}
