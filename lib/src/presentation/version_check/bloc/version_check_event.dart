part of 'version_check_bloc.dart';

@immutable
abstract class VersionCheckEvent {}

final class CheckVersionData extends VersionCheckEvent {
  CheckVersionData({required this.onSuccess, required this.onError});

  final void Function(VersionCheck val) onSuccess;
  final void Function(Object e, StackTrace? st) onError;
}
