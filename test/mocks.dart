import 'dart:async';

import 'package:gato_id_generator/src/core/constants/_constants.dart';
import 'package:gato_id_generator/src/core/_core.dart';
import 'package:gato_id_generator/src/core/exceptions/_exceptions.dart';
import 'package:gato_id_generator/src/domain/repository/version_repo.dart';
import 'package:hive_ce/hive.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';

class MockDio extends Mock implements Dio {}

class MockApiService extends Mock implements ApiService {}

class MockDioException extends Mock implements DioException {}

class MockPackageInfo extends Mock implements PackageInfoWrapper {}

class MockTimer extends Mock implements Timer {}

class MockErrorLogger extends Mock implements ErrorLogger {}

class MockVersionCheckRepo extends Mock implements VersionCheckRepo {}

class MockInternetConnection extends Mock implements InternetConnection {}

class MockHiveBox<T> extends Mock implements Box<T> {}

class MockCallback extends Mock {
  void call();
}

class Listener<T> extends Mock {
  void call(T? previous, T next);
}
