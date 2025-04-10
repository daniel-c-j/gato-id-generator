// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'profile_bloc.dart';

@immutable
abstract class ProfileEvent {}

class ProfileSignOut extends ProfileEvent {
  ProfileSignOut({
    required this.onSuccess,
    required this.onError,
  });

  final VoidCallback onSuccess;
  final void Function(Object? e, StackTrace st) onError;

  @override
  bool operator ==(covariant ProfileSignOut other) {
    if (identical(this, other)) return true;

    return other.onSuccess == onSuccess && other.onError == onError;
  }

  @override
  int get hashCode => onSuccess.hashCode ^ onError.hashCode;

  @override
  String toString() => 'ProfileSignOut(onSuccess: $onSuccess, onError: $onError)';
}
