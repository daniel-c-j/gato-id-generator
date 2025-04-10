import 'package:gato_id_generator/src/util/navigation.dart';
import 'package:gato_id_generator/src/core/routing/app_router.dart';
import 'package:gato_id_generator/src/core/routing/not_found_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  testWidgets('NotFoundScreen displays correct messages', (WidgetTester tester) async {
    // * Arrange
    await tester.pumpWidget(
      const MaterialApp(home: NotFoundScreen(redirect: false)),
    );

    // * Act
    await tester.pumpAndSettle();

    // * Assert
    expect(find.byKey(NotFoundScreen.titleKey), findsOneWidget);
    expect(find.byKey(NotFoundScreen.messageKey), findsOneWidget);
  });

  testWidgets('NotFoundScreen redirects to home page after 3 seconds', (WidgetTester tester) async {
    // * Arrange
    bool isInhome = false;

    final router = GoRouter(
      initialLocation: '/404',
      navigatorKey: NavigationService.navigatorKey,
      routes: [
        GoRoute(
          name: AppRoute.home.name,
          path: '/',
          builder: (context, state) => Scaffold(
            body: Builder(builder: (context) {
              isInhome = true; // * assertion
              return const Text('Home');
            }),
          ),
        ),
        GoRoute(
          name: AppRoute.unknown.name,
          path: '/404',
          builder: (context, state) => const NotFoundScreen(),
        ),
      ],
    );
    // Build
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));

    // * Act
    await tester.pumpAndSettle();
    await tester.pump(Duration(seconds: 3)); // Simulate the passage of 3 seconds

    // * Assert
    expect(isInhome, isTrue);
  });
}
