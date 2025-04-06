part of 'profile_bloc.dart';

@immutable
abstract class ProfileState {}

class ProfileIdle extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileError extends ProfileState {}
