import 'package:gato_id_generator/src/core/constants/_constants.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../mocks.dart';

void main() {
  test("Init method set the valid information for AppInfo properties when success.", () async {
    // Arrange
    final mockPackageInfoObj = PackageInfo(
      appName: '',
      packageName: 'com.example.app',
      version: '1.0.0',
      buildNumber: '123',
      buildSignature: 'signature',
    );
    final mockPackageInfo = MockPackageInfo();
    when(() => mockPackageInfo.fromPlatform()).thenAnswer((_) async => mockPackageInfoObj);

    // Act
    await AppInfo.init(mockPackageInfo);

    // Assert
    expect(AppInfo.CURRENT_VERSION, mockPackageInfoObj.version);
    expect(AppInfo.PACKAGE_NAME, mockPackageInfoObj.packageName);
    expect(AppInfo.BUILD_NUMBER, mockPackageInfoObj.buildNumber);
    expect(AppInfo.BUILD_SIGNATURE, mockPackageInfoObj.buildSignature);
  });

  test("Init method set unknown for all information in AppInfo properties when UNKNOWN.", () async {
    // Arrange
    final mockPackageInfo = MockPackageInfo();
    when(() => mockPackageInfo.fromPlatform()).thenThrow(Exception);

    // Act
    await AppInfo.init(mockPackageInfo);

    // Assert
    expect(AppInfo.CURRENT_VERSION, AppInfo.unknown);
    expect(AppInfo.PACKAGE_NAME, AppInfo.unknown);
    expect(AppInfo.BUILD_NUMBER, AppInfo.unknown);
    expect(AppInfo.BUILD_SIGNATURE, AppInfo.unknown);
  });
}
