// coverage:ignore-file
// ignore_for_file: library_private_types_in_public_api

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';

import '../../constants/_constants.dart';

part 'platform_brightness_event.dart';

class PlatformBrightnessBloc extends Bloc<PlatformBrightnessEvent, Brightness> {
  _PlatformBrightnessObserver? observer;
  Box<bool>? _box;

  PlatformBrightnessBloc() : super(WidgetsBinding.instance.platformDispatcher.platformBrightness) {
    observer = _PlatformBrightnessObserver(
      onBrightnessChanged: (brightness) {},
    );

    // Listening to brightness changes.
    if (observer != null) WidgetsBinding.instance.addObserver(observer!);

    on<BrightnessChange>((event, emit) async {
      final value = event.to;
      if (event.persist) await _setConf(value == Brightness.light); // This talks to local database directly.
      emit(value);
    });
  }

  @override
  Future<void> close() async {
    if (observer != null) WidgetsBinding.instance.removeObserver(observer!);
    await _box?.close();
    return super.close();
  }

  /// Used in early app initialization to remember latest configuration.
  Future<void> init() async {
    late bool isLightMode;

    try {
      _box = Hive.box<bool>(DBKeys.BRIGHTNESS_BOX);
      isLightMode = await _getConf();
    } catch (e) {
      isLightMode = true;
    }

    // False persistance since it's only an initialization.
    if (isLightMode) return add(BrightnessChange(to: Brightness.light, persist: false));
    return add(BrightnessChange(to: Brightness.dark, persist: false));
  }

  Future<bool> _getConf() async {
    _box = Hive.box<bool>(DBKeys.BRIGHTNESS_BOX);
    return _box!.get(DBKeys.BRIGHTNESS_LIGHT, defaultValue: Default.BRIGHTNESS_LIGHT)!;
  }

  Future<void> _setConf(bool newValue) async => _box?.put(DBKeys.BRIGHTNESS_LIGHT, newValue);
}

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

/// Observes platform brightness changes and notifies the listener.
class _PlatformBrightnessObserver with WidgetsBindingObserver {
  const _PlatformBrightnessObserver({required this.onBrightnessChanged});

  final ValueChanged<Brightness> onBrightnessChanged;

  @override
  void didChangePlatformBrightness() {
    onBrightnessChanged(
      WidgetsBinding.instance.platformDispatcher.platformBrightness,
    );
  }
}
