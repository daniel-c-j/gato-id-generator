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
}
