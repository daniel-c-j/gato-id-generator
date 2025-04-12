import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gato_id_generator/src/core/_core.dart' hide getIt;
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks.dart';

void main() {
  final getIt = GetIt.instance;
  late InternetConnection internetConnection;
  late ConnectivityCubit connectivityCubit;

  setUp(() {
    // Must be registered first.
    internetConnection = MockInternetConnection();
    getIt.registerLazySingleton<InternetConnection>(() => internetConnection);
  });

  tearDown(() {
    connectivityCubit.close();
    getIt.unregister<InternetConnection>();
  });

  test('connectivity service cubit ...', () async {
    when(() => internetConnection.onStatusChange.listen((InternetStatus status) {}, onError: (error) {}))
        .thenAnswer((_) {
      // Simulate a stream that emits connected status
      return Stream.value(InternetStatus.disconnected);
    });
    connectivityCubit = ConnectivityCubit();

    // Stub the state stream
    whenListen(
      connectivityCubit,
      Stream.fromIterable([false, true, false]),
      initialState: false,
    );

    // Assert that the initial state is correct.
    expect(connectivityCubit.state, equals(0));

    // Assert that the stubbed stream is emitted.
    await expectLater(connectivityCubit.stream, emitsInOrder([false, true, false]));

    // Assert that the current state is in sync with the stubbed stream.
    expect(connectivityCubit.state, equals(false));

    // Act
    // final expectedStates = [true]; // Expecting to emit true when connected
    // expectLater(yourBloc.stream, emitsInOrder(expectedStates));

    // // Start the BLoC
    // yourBloc.startListening();
  });
}
