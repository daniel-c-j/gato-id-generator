import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gato_id_generator/src/core/_core.dart';

void main() {
  testWidgets('''
    NavigationService provides current context, current state, and current widget.
  ''', (WidgetTester tester) async {
    // * Arrange
    // Create a MaterialApp with a Navigator
    final widget = MaterialApp(
      navigatorKey: NavigationService.navigatorKey,
      home: const SizedBox(),
    );

    // * Action
    await tester.pumpWidget(widget);

    // * Assert
    // Verify that the current context is not null
    expect(NavigationService.currentContext, isNotNull);
    expect(NavigationService.currentContext, isA<BuildContext>());

    // Verify that the current state is not null
    expect(NavigationService.currentState, isNotNull);
    expect(NavigationService.currentState, isA<NavigatorState>());

    // Verify that the current widget is not null
    expect(NavigationService.currentWidget, isNotNull);
    expect(NavigationService.currentWidget, isA<Widget>());
  });
}
