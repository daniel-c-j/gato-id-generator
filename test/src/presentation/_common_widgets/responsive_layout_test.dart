import 'package:gato_id_generator/src/presentation/_common_widgets/responsive_layout.dart';
import 'package:gato_id_generator/src/core/constants/_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const desktopWidget = Text('Desktop');
  const tabletWidget = Text('Tablet');
  const mobileWidget = Text('Mobile');
  const wearOSWidget = Text('WearOS');

  testWidgets('ResponsiveLayout shows desktop widget for desktop width', (WidgetTester tester) async {
    // * Arrange
    const layout = ResponsiveLayout(
      width: Breakpoint.DESKTOP + 1, // Simulate a desktop width
      desktop: desktopWidget,
      tablet: tabletWidget,
      mobile: mobileWidget,
      wearOS: wearOSWidget,
    );
    // Build the widget
    await tester.pumpWidget(const MaterialApp(home: Scaffold(body: layout)));

    // * Act
    await tester.pumpAndSettle();

    // * Assert
    expect(find.text('Desktop'), findsOneWidget);
    expect(find.text('Tablet'), findsNothing);
    expect(find.text('Mobile'), findsNothing);
    expect(find.text('WearOS'), findsNothing);
  });

  testWidgets('ResponsiveLayout shows tablet widget for tablet width', (WidgetTester tester) async {
    // * Arrange
    const layout = ResponsiveLayout(
      width: Breakpoint.TABLET + 1, // Simulate a tablet width
      desktop: desktopWidget,
      tablet: tabletWidget,
      mobile: mobileWidget,
      wearOS: wearOSWidget,
    );
    // Build the widget
    await tester.pumpWidget(const MaterialApp(home: Scaffold(body: layout)));

    // * Act
    await tester.pumpAndSettle();

    // * Assert
    expect(find.text('Tablet'), findsOneWidget);
    expect(find.text('Desktop'), findsNothing);
    expect(find.text('Mobile'), findsNothing);
    expect(find.text('WearOS'), findsNothing);
  });

  testWidgets('ResponsiveLayout shows mobile widget for mobile width', (WidgetTester tester) async {
    // * Arrange
    const layout = ResponsiveLayout(
      width: Breakpoint.MOBILE + 1, // Simulate a mobile width
      desktop: desktopWidget,
      tablet: tabletWidget,
      mobile: mobileWidget,
      wearOS: wearOSWidget,
    );
    // Build the widget
    await tester.pumpWidget(const MaterialApp(home: Scaffold(body: layout)));

    // * Act
    await tester.pumpAndSettle();

    // * Assert
    expect(find.text('Mobile'), findsOneWidget);
    expect(find.text('Desktop'), findsNothing);
    expect(find.text('Tablet'), findsNothing);
    expect(find.text('WearOS'), findsNothing);
  });

  testWidgets('ResponsiveLayout shows wearOS widget for widths below mobile', (WidgetTester tester) async {
    // * Arrange
    const layout = ResponsiveLayout(
      width: Breakpoint.MOBILE - 1, // Simulate a width below mobile
      desktop: desktopWidget,
      tablet: tabletWidget,
      mobile: mobileWidget,
      wearOS: wearOSWidget,
    );
    // Build the widget
    await tester.pumpWidget(const MaterialApp(home: Scaffold(body: layout)));

    // * Act
    await tester.pumpAndSettle();

    // * Assert
    expect(find.text('WearOS'), findsOneWidget);
    expect(find.text('Desktop'), findsNothing);
    expect(find.text('Tablet'), findsNothing);
    expect(find.text('Mobile'), findsNothing);
  });
}
