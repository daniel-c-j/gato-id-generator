import 'package:bloc_test/bloc_test.dart';
import 'package:gato_id_generator/src/core/_core.dart';
import 'package:gato_id_generator/src/core/constants/_constants.dart';
import 'package:gato_id_generator/src/core/exceptions/_exceptions.dart';
import 'package:gato_id_generator/src/data/repository/version_check/remote_version_check_repo.dart';
import 'package:gato_id_generator/src/domain/repository/version_repo.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gato_id_generator/src/domain/use_case/version_check_usecase.dart';
import 'package:gato_id_generator/src/presentation/version_check/bloc/version_check_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:gato_id_generator/src/data/model/version_check.dart';
import 'package:version/version.dart';

import '../../../../mocks.dart';

void main() {
  // Mocking value.
  AppInfo.CURRENT_VERSION = "0.9.0";

  late VersionCheckBloc versionCheckBloc;
  late VersionCheckUsecase versionCheckUsecase;

  VersionCheck? returnedVersionCheck;
  AppException? error;

  setUp(() {
    versionCheckUsecase = MockVersionCheckUsecase();
    versionCheckBloc = VersionCheckBloc(versionCheckUsecase);

    // Registering dependency injection to prevent error result.
    if (!getIt.isRegistered<VersionCheckRepo>()) {
      getIt.registerLazySingleton<VersionCheckRepo>(() => RemoteVersionCheckRepo(getIt<ApiService>()));
    }
    if (!getIt.isRegistered<NetworkErrorHandlerService>()) {
      getIt.registerLazySingleton<NetworkErrorHandlerService>(() => const NetworkErrorHandlerService());
    }
  });

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
    test("Initial state is idle.", () {
      expect(versionCheckBloc.state, isA<VersionCheckIdle>());
    });

    blocTest(
      '''
      Given getVersionCheck state is valid.
      When checkData is called.
      Then onSuccess callback is returned with the VersionCheck value.
      And state has no error.
    ''',
      build: () => versionCheckBloc,
      act: (bloc) {
        when(() => versionCheckUsecase.execute()).thenAnswer((_) async => Future.value(mockVersionCheck()));
        bloc.add(
          CheckVersionData(onSuccess: (val) => returnedVersionCheck = val, onError: (e, st) {}),
        );
      },
      expect: () => [isA<VersionCheckLoading>(), isA<VersionCheckIdle>()],
      verify: (_) {
        expect(returnedVersionCheck, mockVersionCheck());
        verify(() => versionCheckUsecase.execute()).called(1);
      },
      tearDown: () {
        returnedVersionCheck = null;
        error = null;
      },
    );

    blocTest(
      '''
      Given getVersionCheck state is valid.
      When checkData is called.
      Then onSuccess callback is returned with the VersionCheck value.
      And state has no error.
    ''',
      build: () => versionCheckBloc,
      act: (bloc) {
        when(() => versionCheckUsecase.execute()).thenThrow(mockRegularException());
        bloc.add(
          CheckVersionData(onSuccess: (_) {}, onError: (e, _) => error = e as AppException),
        );
      },
      expect: () => [isA<VersionCheckLoading>(), isA<VersionCheckIdle>()],
      verify: (_) {
        expect(error, const UpdateCheckException());
        verify(() => versionCheckUsecase.execute()).called(1);
      },
      tearDown: () {
        returnedVersionCheck = null;
        error = null;
      },
    );

    test('''
      Given there's a network error.
      When handleErrors is called.
      Then onError callback is returned alongside a formatted AppException from DioException.
      And state has error.
    ''', () async {
      // * Arrange
      late final AppException error;

      // * Act
      versionCheckBloc.handleErrors(
        mock404Exception(),
        StackTrace.fromString(""),
        onError: (e, _) => error = e as AppException,
      );

      // * Assert
      // NotFoundException code is 404.
      expect(error, const NotFoundException());
    });

    test('''
      Given there's a general error.
      When handleErrors is called.
      Then onError callback is returned alongside UpdateCheckException.
      And state has error.
    ''', () async {
      // * Arrange
      late final AppException error;

      // * Act
      versionCheckBloc.handleErrors(
        mockRegularException(),
        StackTrace.fromString(""),
        onError: (e, _) => error = e as AppException,
      );

      // * Assert
      expect(error, const UpdateCheckException());
    });
  });
}
