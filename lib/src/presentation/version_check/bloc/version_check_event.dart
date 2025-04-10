// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'version_check_bloc.dart';

@immutable
abstract class VersionCheckEvent {}

class CheckVersionData extends VersionCheckEvent {
  CheckVersionData({
    required this.onSuccess,
    required this.onError,
  });

  final void Function(VersionCheck val) onSuccess;
  final void Function(Object e, StackTrace? st) onError;

  @override
  String toString() => 'CheckVersionData(onSuccess: $onSuccess, onError: $onError)';

  @override
  bool operator ==(covariant CheckVersionData other) {
    if (identical(this, other)) return true;

    return other.onSuccess == onSuccess && other.onError == onError;
  }

  @override
  int get hashCode => onSuccess.hashCode ^ onError.hashCode;
}
