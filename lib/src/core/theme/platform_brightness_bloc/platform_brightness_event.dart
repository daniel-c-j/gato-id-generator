// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'platform_brightness_bloc.dart';

@immutable
abstract class PlatformBrightnessEvent {}

final class BrightnessChange extends PlatformBrightnessEvent {
  BrightnessChange({required this.to, this.persist = true});

  final Brightness to;
  final bool persist;

  @override
  bool operator ==(covariant BrightnessChange other) {
    if (identical(this, other)) return true;

    return other.to == to && other.persist == persist;
  }

  @override
  int get hashCode => to.hashCode ^ persist.hashCode;
}
