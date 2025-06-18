import 'package:gato_id_generator/src/util/debouncer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks.dart';

void main() {
  late Debouncer debouncer;

  setUp() {
    debouncer = Debouncer(delay: Duration(milliseconds: 300));
  }

  teardown() {
    debouncer.dispose;
  }

  test('should call the callback after the specified delay', () async {
    // * Arrange
    final mockCallback = MockCallback();

    // * Action
    debouncer.call(mockCallback.call);
    await Future.delayed(Duration(milliseconds: 400)); // Wait longer than the delay

    // * Assert
    verify(mockCallback.call).called(1);
  });

  test('should not call the callback if called multiple times within the delay', () async {
    // * Arrange
    final mockCallback = MockCallback();

    // * Action
    debouncer.call(mockCallback.call);
    debouncer.call(mockCallback.call); // Call again before the delay
    await Future.delayed(Duration(milliseconds: 400)); // Wait longer than the delay

    // * Assert
    verify(mockCallback.call).called(1); // Should still only be called once
  });

  test('should cancel the previous timer when called again', () async {
    // * Arrange
    final mockCallback = MockCallback();

    // * Action
    debouncer.call(mockCallback.call);
    await Future.delayed(Duration(milliseconds: 100)); // Wait a bit
    debouncer.call(mockCallback.call); // Call again before the delay
    await Future.delayed(Duration(milliseconds: 400)); // Wait longer than the delay

    // * Assert
    verify(mockCallback.call).called(1); // Should still only be called once
  });
}
