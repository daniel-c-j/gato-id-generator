import 'package:bloc/bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gato_id_generator/src/core/app/bloc_observer.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks.dart';

void main() {
  group('AppBlocObserver', () {
    late MockErrorLogger mockErrorLogger;
    late AppBlocObserver appBlocObserver;

    setUp(() {
      mockErrorLogger = MockErrorLogger();
      appBlocObserver = AppBlocObserver(mockErrorLogger);
      Bloc.observer = appBlocObserver; // Set the observer globally
    });

    test('''
      Given an AppBlocObserver, 
      When onError is called, 
      Then it should log the error
    ''', () {
      // Arrange
      final bloc = MockBloc<dynamic, dynamic>();
      final error = Exception('Test error');
      final stackTrace = StackTrace.current;

      // Act
      appBlocObserver.onError(bloc, error, stackTrace);

      // Assert
      verify(() => mockErrorLogger.log("${bloc.toString()}/n${error.toString()}", stackTrace)).called(1);
    });
  });
}
