import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('CustomButton should call onTap when tapped', (WidgetTester tester) async {
    // * Arrange
    bool wasTapped = false;
    final button = CustomButton(
      onTap: () {
        wasTapped = true;
      },
      child: const Text('Tap me'),
    );
    // Build the widget
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: button)));

    // * Act
    await tester.tap(find.text('Tap me'));
    await tester.pumpAndSettle(); // Wait for animations to complete

    // * Assert
    expect(wasTapped, isTrue);
  });

  testWidgets('CustomButton should show tooltip when msg is provided', (WidgetTester tester) async {
    // * Arrange
    final button = CustomButton(
      onTap: () {},
      msg: 'This is a button',
      child: const Text('Tap me'),
    );
    // Build the widget
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: button)));

    // * Act
    final tooltipFinder = find.byTooltip('This is a button');

    // * Assert
    expect(tooltipFinder, findsOneWidget);
  });

  testWidgets('CustomButton should not show tooltip when msg is null', (WidgetTester tester) async {
    // * Arrange
    final button = CustomButton(
      onTap: () {},
      msg: null, // No tooltip message
      child: const Text('Tap me'),
    );
    // Build the widget
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: button)));

    // * Act
    final tooltipFinder = find.byTooltip('This is a button');

    // * Assert
    expect(tooltipFinder, findsNothing);
  });
}
