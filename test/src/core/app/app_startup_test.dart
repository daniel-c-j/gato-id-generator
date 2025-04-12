import 'dart:ui';

import 'package:gato_id_generator/src/core/app/app_startup.dart';
import 'package:gato_id_generator/src/core/exceptions/_exceptions.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks.dart';

void main() {
  ErrorLogger makeErrorLogger() => MockErrorLogger();
  void registerErrorHandlers(ErrorLogger log) => AppStartup().registerErrorHandlers(log);

  group('Initialize error handlers', () {
    test('FlutterError.onError should log error', () {
      // * Arrange
      final mockErrorLogger = makeErrorLogger();
      registerErrorHandlers(mockErrorLogger);

      final errorDetails = FlutterErrorDetails(
        exception: Exception('Test exception'),
        stack: StackTrace.current,
      );

      // * Act
      FlutterError.onError!(errorDetails);

      // * Assert
      verify(() => mockErrorLogger.log(errorDetails.exception, errorDetails.stack)).called(1);
    });

    test('PlatformDispatcher.instance.onError should log error', () {
      // * Arrange
      final mockErrorLogger = makeErrorLogger();
      registerErrorHandlers(mockErrorLogger);
      final error = Exception('Platform error');
      final stackTrace = StackTrace.current;

      // * Act
      final result = PlatformDispatcher.instance.onError!(error, stackTrace);

      // * Assert
      verify(() => mockErrorLogger.log(error, stackTrace)).called(1);
      expect(result, isTrue);
    });

    testWidgets('ErrorWidget.builder should return custom error widget', (WidgetTester tester) async {
      // * Arrange
      final mockErrorLogger = makeErrorLogger();
      registerErrorHandlers(mockErrorLogger);
      final errorDetails = FlutterErrorDetails(
        exception: Exception('Test exception'),
        stack: StackTrace.current,
      );

      // * Act
      final errorWidget = ErrorWidget.builder(errorDetails);

      // Build the widget tree
      await tester.pumpWidget(MaterialApp(home: errorWidget));

      // * Assert
      expect(find.text('An error occurred'), findsOneWidget);
      expect(find.text(errorDetails.toString()), findsOneWidget);
    });
  });
}
