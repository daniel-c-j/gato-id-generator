part of 'version_check_bloc.dart';

@immutable
abstract class VersionCheckState {}

class VersionCheckIdle extends VersionCheckState {}

class VersionCheckLoading extends VersionCheckState {}

class VersionCheckError extends VersionCheckState {}
