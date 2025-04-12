import 'package:gato_id_generator/src/data/repository/version_check/remote_version_check_repo.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:gato_id_generator/src/core/constants/app_info.dart';
import 'package:gato_id_generator/src/core/constants/network_constants.dart';
import 'package:gato_id_generator/src/core/network/api_service.dart';
import 'package:gato_id_generator/src/data/model/version_check.dart';
import 'package:version/version.dart';

import '../../../../mocks.dart';

void main() {
  RemoteVersionCheckRepo makeVersionCheckRepo(ApiService apiService) => RemoteVersionCheckRepo(apiService);

  // Changing value for testing.
  NetConsts.URL_CHECK_VERSION = "";
  AppInfo.CURRENT_VERSION = "0.9.0";

  VersionCheck mockVersionCheck() => VersionCheck(
        latestVersion: Version(1, 0, 0),
        canUpdate: Version(1, 0, 0) > Version.parse(AppInfo.CURRENT_VERSION),
        mustUpdate: Version(0, 1, 0, preRelease: ["alpha"]) > Version.parse(AppInfo.CURRENT_VERSION),
        requiredToUpdateVer: Version(0, 1, 0, preRelease: ["alpha"]),
      );

  Response mockResponse() => Response(
        requestOptions: RequestOptions(),
        statusCode: 200,
        data: '{"latestV": "1.0.0", "requiredV": "0.1.0-alpha"}',
      );

  Response mockErrResponse() => Response(
        requestOptions: RequestOptions(),
        statusCode: 404,
        data: null,
      );

  group('RemoteVersionCheckRepo', () {
    test("getVersionCheck returns a Future of VersionCheck.", () async {
      // * Arrange
      final apiService = MockApiService();
      when(() => apiService.get(url: NetConsts.URL_CHECK_VERSION)).thenAnswer((_) async => mockResponse());

      // * Act
      final versionCheckRepo = makeVersionCheckRepo(apiService);
      final getVersionCheck = versionCheckRepo.getVersionCheck();

      // * Assert
      expect(getVersionCheck, isA<Future<void>>());
      expect(await getVersionCheck, mockVersionCheck());

      verify(() => apiService.get(url: NetConsts.URL_CHECK_VERSION)).called(1);
    });

    test("getVersionCheck throws Exception when operation invalid.", () async {
      // * Arrange
      final apiService = MockApiService();
      when(() => apiService.get(url: NetConsts.URL_CHECK_VERSION)).thenThrow(DioException);

      // * Act
      final versionCheckRepo = makeVersionCheckRepo(apiService);
      versionCheck() async => await versionCheckRepo.getVersionCheck();

      // * Assert
      expect(versionCheck, throwsA(DioException));
      verify(() => apiService.get(url: NetConsts.URL_CHECK_VERSION)).called(1);
    });

    test('fetchLatestVersion returns a Future of Response when api call is valid.', () async {
      // * Arrange
      final apiService = MockApiService();
      when(() => apiService.get(url: NetConsts.URL_CHECK_VERSION)).thenAnswer((_) async => mockResponse());

      // * Act
      final versionCheckRepo = makeVersionCheckRepo(apiService);
      final fetchLatestVer = versionCheckRepo.fetchLatestVersion();

      // * Assert
      expect(fetchLatestVer, isA<Future<Response>>());

      // Expect result to be the same.
      final response = await fetchLatestVer;
      expect(response.toString(), mockResponse().toString());

      // Verify the method called only once.
      verify(() => apiService.get(url: NetConsts.URL_CHECK_VERSION)).called(1);
    });

    test('fetchLatestVersion throws Exception when api call is invalid.', () async {
      // * Arrange
      final apiService = MockApiService();
      when(() => apiService.get(url: NetConsts.URL_CHECK_VERSION)).thenThrow(DioException);

      // * Act
      final versionCheckRepo = makeVersionCheckRepo(apiService);
      fetchLatestVer() => versionCheckRepo.fetchLatestVersion();

      // * Assert
      expect(fetchLatestVer, throwsA(DioException));

      // Verify the method called only once.
      verify(() => apiService.get(url: NetConsts.URL_CHECK_VERSION)).called(1);
    });

    test("parseVersionFromResponse returns VersionCheck when response is valid.", () {
      // * Arrange
      final apiService = MockApiService();
      final versionCheckRepo = makeVersionCheckRepo(apiService);

      // * Act
      final versionCheck = versionCheckRepo.parseVersionFromResponse(mockResponse());

      // * Assert
      expect(versionCheck, mockVersionCheck());
    });

    test("parseVersionFromResponse throws Exception when response is invalid.", () {
      // * Arrange
      final apiService = MockApiService();
      final versionCheckRepo = makeVersionCheckRepo(apiService);

      // * Act
      versionCheck() => versionCheckRepo.parseVersionFromResponse(mockErrResponse());

      // * Assert
      expect(versionCheck, throwsA(anything));
    });

    test("parseToVersion returns Version when data is valid.", () {
      // * Arrange
      final apiService = MockApiService();
      final versionCheckRepo = makeVersionCheckRepo(apiService);

      // *Act
      final version = versionCheckRepo.parseToVersion("1.2.0-beta+24");
      final expectedVersion = Version(1, 2, 0, preRelease: ["beta"], build: "24");

      // * Assert
      expect(version, expectedVersion);
    });

    test("parseToVersion throws Exception when data is invalid.", () {
      // * Arrange
      final apiService = MockApiService();
      final versionCheckRepo = makeVersionCheckRepo(apiService);

      // *Act
      version() => versionCheckRepo.parseToVersion("version 1.20.0.1-b+024");

      // * Assert
      expect(version, throwsFormatException);
    });
  });
}
