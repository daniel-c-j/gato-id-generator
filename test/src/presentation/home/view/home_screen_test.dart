import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:gato_id_generator/src/core/_core.dart';
import 'package:gato_id_generator/src/presentation/about/about_screen.dart';
import 'package:gato_id_generator/src/presentation/auth/sign_in/view/sign_in_screen.dart';
import 'package:gato_id_generator/src/presentation/home/view/home_screen.dart';

import '../../../../robot.dart';

void main() {
  setUp(() async {
    try {
      // Hive reset
      await Directory('temp').delete(recursive: true);
      getIt.reset(dispose: true);
    } catch (e) {
      // print("ERROR");
      // print(e);
    }
  });

  // * Note: All tests are wrapped with `runAsync` to prevent this error:
  // * A Timer is still pending even after the widget tree was disposed.

  testWidgets('Homescreen layout is correct.', (tester) async {
    await tester.runAsync(() async {
      final r = Robot(tester);
      await r.pumpApp();
      await r.home.expectInitialLayoutIsCorrect();
    });
  });

  testWidgets('''
    Given Homescreen is rendered,
    When about button is tapped,
    Then screen should change into AboutScreen.
  ''', (tester) async {
    await tester.runAsync(() async {
      final r = Robot(tester);
      await r.pumpApp();

      await r.home.tapAboutIconButton();
      expect(find.byType(HomeScreen), findsNothing);
      expect(find.byType(AboutScreen), findsOneWidget);
    });
  });

  testWidgets('''
    Given Homescreen is rendered and state is initial,
    When generate cat button is tapped,
    Then screen should change into EmailPasswordSignInScreen.
  ''', (tester) async {
    await tester.runAsync(() async {
      final r = Robot(tester);
      await r.pumpApp();

      await r.home.tapGenerateGatoButton();

      expect(find.byType(HomeScreen), findsNothing);
      expect(find.byType(EmailPasswordSignInScreen), findsOneWidget);
    });
  });
}
