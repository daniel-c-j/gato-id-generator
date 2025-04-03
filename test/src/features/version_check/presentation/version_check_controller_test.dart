import 'package:gato_id_generator/src/core/constants/_constants.dart';
import 'package:gato_id_generator/src/data/repository/remote_version_repo.dart';
import 'package:gato_id_generator/src/domain/repository/version_repo.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:gato_id_generator/src/core/exceptions/app_exception.dart';
import 'package:gato_id_generator/src/data/model/version_check.dart';
import 'package:gato_id_generator/src/presentation/version_check/bloc/version_check_controller.dart';
import 'package:version/version.dart';

import '../../../../mocks.dart';

void main() {
  // Mocking value.
  AppInfo.CURRENT_VERSION = "0.9.0";

  ProviderContainer makeProviderContainer(VersionCheckRepo versionCheckRepo) {
    final container = ProviderContainer(
      overrides: [
        versionCheckRepoProvider.overrideWithValue(versionCheckRepo),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  VersionCheck mockVersionCheck() => VersionCheck(
        latestVersion: Version(1, 0, 0),
        canUpdate: Version(1, 0, 0) > Version.parse(AppInfo.CURRENT_VERSION),
        mustUpdate: Version(0, 1, 0, preRelease: ["alpha"]) > Version.parse(AppInfo.CURRENT_VERSION),
        requiredToUpdateVer: Version(0, 1, 0, preRelease: ["alpha"]),
      );

  DioException mock404Exception() => DioException(
        response: Response(
          statusCode: 404,
          requestOptions: RequestOptions(),
        ),
        requestOptions: RequestOptions(),
      );

  Exception mockRegularException() => Exception("test");

  group("VersionCheckController", () {
    test("Initial state is null.", () {
      // * Arrange
      final versionCheckRepo = MockVersionCheckRepo();
      final container = makeProviderContainer(versionCheckRepo);

      // * Act
      final controller = container.read(versionCheckControllerProvider);

      // * Assert
      expect(controller, const AsyncData<void>(null));
    });

    test('''
      Given getVersionCheck state is valid.
      When checkData is called.
      Then onSuccess callback is returned with the VersionCheck value.
      And state has no error.
    ''', () async {
      // * Arrange
      final versionCheckRepo = MockVersionCheckRepo();
      when(() => versionCheckRepo.getVersionCheck())
          .thenAnswer((_) async => Future.value(mockVersionCheck()));

      final container = makeProviderContainer(versionCheckRepo);
      final controller = container.read(versionCheckControllerProvider);
      final notifier = container.read(versionCheckControllerProvider.notifier);

      // Flag indicators.
      final states = <AsyncValue<void>>[];
      late final VersionCheck returnedVersionCheck;

      // * Pre-Act
      // Initial value is null.
      expect(controller, const AsyncData<void>(null));

      // * Act
      // Create listener and listen to the provider.
      container.listen(
        versionCheckControllerProvider,
        (prev, next) => states.add(next),
        fireImmediately: true,
      );
      await notifier.checkData(onSuccess: (val) => returnedVersionCheck = val, onError: (_, __) {});

      // * Assert
      expect(returnedVersionCheck, mockVersionCheck());
      expect(states, [
        const AsyncData<void>(null),
        isA<AsyncLoading<void>>(),
        const AsyncData<void>(null),
      ]);

      verify(() => versionCheckRepo.getVersionCheck()).called(1);
    });

    test('''
      Given getVersionCheck state is invalid or has error/exception.
      When checkData is called.
      Then onError callback is returned.
      And state has an error.
    ''', () async {
      // * Arrange
      final versionCheckRepo = MockVersionCheckRepo();
      when(() => versionCheckRepo.getVersionCheck()).thenThrow(mockRegularException());

      final container = makeProviderContainer(versionCheckRepo);
      final controller = container.read(versionCheckControllerProvider);
      final notifier = container.read(versionCheckControllerProvider.notifier);

      // Flag indicators.
      final states = <AsyncValue<void>>[];
      late AppException error;

      // * Pre-Act
      // Initial value is null.
      expect(controller, const AsyncData<void>(null));

      // * Act
      // Create listener and listen to the provider.
      container.listen(
        versionCheckControllerProvider,
        (prev, next) => states.add(next),
        fireImmediately: true,
      );
      await notifier.checkData(onSuccess: (_) {}, onError: (e, _) => error = e as AppException);

      // * Assert
      expect(error, const UpdateCheckException());
      expect(states, [
        const AsyncData<void>(null),
        isA<AsyncLoading<void>>(),
        isA<AsyncError<void>>(),
      ]);

      verify(() => versionCheckRepo.getVersionCheck()).called(1);
    });

    test('''
      Given there's a network error.
      When handleErrors is called.
      Then onError callback is returned alongside a formatted AppException from DioException.
      And state has error.
    ''', () async {
      // * Arrange
      final versionCheckRepo = MockVersionCheckRepo();
      final container = makeProviderContainer(versionCheckRepo);
      final notifier = container.read(versionCheckControllerProvider.notifier);

      // Flag indicators.
      late final AppException error;

      // * Act
      notifier.handleErrors(mock404Exception(), onError: (e, _) => error = e as AppException);

      // * Assert
      // NotFoundException code is 404.
      expect(error, NotFoundException());
    });

    test('''
      Given there's a general error.
      When handleErrors is called.
      Then onError callback is returned alongside UpdateCheckException.
      And state has error.
    ''', () async {
      // * Arrange
      final versionCheckRepo = MockVersionCheckRepo();
      final container = makeProviderContainer(versionCheckRepo);
      final notifier = container.read(versionCheckControllerProvider.notifier);

      // Flag indicators.
      late final AppException error;

      // * Act
      notifier.handleErrors(mockRegularException(), onError: (e, _) => error = e as AppException);

      // * Assert
      expect(error, UpdateCheckException());
    });
  });
}
