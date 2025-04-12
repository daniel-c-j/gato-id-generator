import 'package:flutter_test/flutter_test.dart';
import 'package:gato_id_generator/src/core/_core.dart' hide getIt;
import 'package:gato_id_generator/src/util/delay.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks.dart';

void main() {
  final getIt = GetIt.instance;
  late InternetConnection internetConnection;
  ConnectivityCubit? connectivityCubit;

  setUp(() {
    // Must be registered first.
    internetConnection = MockInternetConnection();
    getIt.registerLazySingleton<InternetConnection>(() => internetConnection);
  });

  tearDown(() {
    connectivityCubit?.close();
    getIt.unregister<InternetConnection>();
  });

  test('Connectivity cubit initial state is false', () async {
    when(() => internetConnection.onStatusChange).thenAnswer((_) {
      // Simulate a stream that emits connected status
      return Stream.value(InternetStatus.disconnected);
    });
    connectivityCubit = ConnectivityCubit();

    // Assert that the initial state is correct.
    expect(connectivityCubit?.state, isFalse);
  });

  // TODO migrate to bloctest perhaps?
  test('Connectivity cubit state works', () async {
    // Arrange
    when(() => internetConnection.onStatusChange).thenAnswer((_) {
      // Simulate a stream that emits connected status
      return Stream.fromIterable(
        const [InternetStatus.connected, InternetStatus.disconnected, InternetStatus.connected],
      );
    });
    final tempState = [];

    // Act
    ConnectivityCubit().stream.listen((value) => tempState.add(value));
    await delay(true, 500); // Waits a little bit until stream completed.

    // Assert that the initial state is correct.
    expect(tempState, const [true, false, true]);
  });
}
