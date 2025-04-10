// ignore_for_file: public_member_api_docs, sort_constructors_first
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

  @override
  bool operator ==(covariant EmailPassSignInSubmit other) {
    if (identical(this, other)) return true;

    return other.email == email &&
        other.passw == passw &&
        other.formType == formType &&
        other.onSuccess == onSuccess &&
        other.onError == onError;
  }

  @override
  int get hashCode {
    return email.hashCode ^ passw.hashCode ^ formType.hashCode ^ onSuccess.hashCode ^ onError.hashCode;
  }

  @override
  String toString() {
    return 'EmailPassSignInSubmit(email: $email, passw: $passw, formType: $formType, onSuccess: $onSuccess, onError: $onError)';
  }
}
