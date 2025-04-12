import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:gato_id_generator/src/core/exceptions/network_specific/network_error_handler_service.dart';
import 'package:gato_id_generator/src/core/exceptions/app_exception.dart';

import '../../../../mocks.dart';

void main() {
  late NetworkErrorHandlerService netErrHandler;

  setUp(() {
    netErrHandler = NetworkErrorHandlerService();
  });

  DioException mockNullResponse() => DioException(
        response: null,
        requestOptions: RequestOptions(),
      );

  DioException mock404Exception() => DioException(
        response: Response(
          statusCode: 404,
          requestOptions: RequestOptions(),
        ),
        requestOptions: RequestOptions(),
      );

  DioException mockNoConnectionException() => DioException(
        requestOptions: RequestOptions(),
        error: NoConnectionException(),
        type: DioExceptionType.connectionTimeout,
      );

  DioException mockUnknownStatCodeException() => DioException(
        response: Response(
          statusCode: 998,
          requestOptions: RequestOptions(),
        ),
        requestOptions: RequestOptions(),
      );

  group("NetworkErrorHandlerService", () {
    test(''''
      Given client request to server but there's an error.
      When error is identified as a NoConnectionException.
      Then get NoConnectionException back..
    ''', () {
      // * Act
      final exception = netErrHandler.getFailure(mockNoConnectionException());

      // * Assert
      expect(exception, NoConnectionException());
    });

    test(''''
      Given client request to server.
      When throws a known network issue/exception by statuscode.
      Then get the identified exception.
    ''', () {
      // * Act
      final exception = netErrHandler.getFailure(mock404Exception());

      // * Assert
      expect(exception, NotFoundException());
    });

    test(''''
      Given client request to server.
      When throws a network issue/exception with response of null.
      Then get the UnknownException.
    ''', () {
      // * Act
      final exception = netErrHandler.getFailure(mockNullResponse());

      // * Assert
      expect(exception, UnknownException());
    });

    test(''''
      Given processing network issue.
      When an unknown error occured.
      Then return the UnknownException.
    ''', () {
      // * Arrange
      final mockException = MockDioException();
      when(() => mockException.error).thenThrow(Exception());

      // * Act
      final exception = netErrHandler.getFailure(mockException);

      // * Assert
      expect(exception, UnknownException());
    });

    test(''''
      Given processing network issue.
      When an unknown statuscode.
      Then return CustomException.
    ''', () {
      // * Act
      final exception = netErrHandler.getFailure(mockUnknownStatCodeException());

      // * Assert
      expect(exception, isA<CustomException>());
    });
  });

  group('NetworkErrorHandlerService().extractErrorMessage', () {
    test('''
      Given a string,
      When extractErrorMessage is called, 
      Then it should return the same string
    ''', () {
      // * Arrange
      final errorMessage = 'An error occurred';

      // * Act
      final result = NetworkErrorHandlerService().extractErrorMessage(errorMessage);

      // * Assert
      expect(result, equals(errorMessage));
    });

    test('''
      Given a map with string values, 
      When extractErrorMessage is called, 
      Then it should concatenate the values
    ''', () {
      // * Arrange
      final Map<String, String> errorData = {
        'error1': 'First error',
        'error2': 'Second error',
      };

      // * Act
      final result = NetworkErrorHandlerService().extractErrorMessage(errorData);

      // *  Assert
      expect(result, equals('First error Second error'));
    });

    test('''
      Given a map with list values, 
      When extractErrorMessage is called, 
      Then it should join the list items
    ''', () {
      // *  Arrange
      final Map<String, dynamic> errorData = {
        'error1': ['First error', 'Second error'],
        'error2': 'Third error',
      };

      // * Act
      final result = NetworkErrorHandlerService().extractErrorMessage(errorData);

      // *  Assert
      expect(result, equals('First error \nSecond errorThird error'));
    });

    test('''
      Given a map with mixed types, 
      When extractErrorMessage is called, 
      Then it should handle all types correctly
    ''', () {
      // *  Arrange
      final Map<String, dynamic> errorData = {
        'error1': 'First error',
        'error2': [1, 2, 3],
        'error3': true,
      };

      // *  Act
      final result = NetworkErrorHandlerService().extractErrorMessage(errorData);

      // *  Assert
      expect(result, equals('First error 1 \n2 \n3 true '));
    });

    test('''
      Given unsupported data type, 
      When extractErrorMessage is called, 
      Then it should return an unknown exception message
    ''', () {
      // * Arrange
      final dynamic unsupportedData = 42;

      // * Act
      final result = NetworkErrorHandlerService().extractErrorMessage(unsupportedData);

      // * Assert
      expect(result, UnknownException().toString());
    });
  });
}
