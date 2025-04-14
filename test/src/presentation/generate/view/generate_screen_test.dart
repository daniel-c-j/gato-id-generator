import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:gato_id_generator/src/core/_core.dart';

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

  testWidgets('GenerateScreen layout is correct.', (tester) async {
    await tester.runAsync(() async {
      final r = Robot(tester);
      await r.pumpApp();
      await r.home.tapGenerateGatoButton();
      await r.auth.registerAndSignIn();
      await r.generate.expectInitialLayoutIsCorrect();
    });
  });

  // ? Oddly the auth state is remembered after you run the first test above.
  // TODO fix this?
  testWidgets('''
    Given in GenerateScreen, 
    When not generating anything yet,
    Then save button should not do anything when tapped.
  ''', (tester) async {
    await tester.runAsync(() async {
      final r = Robot(tester);
      await r.pumpApp();
      await r.home.tapGenerateGatoButton();
      // await r.auth.registerAndSignIn();
      // await r.generate.expectInitialLayoutIsCorrect();

      await r.generate.tapSaveGeneratedButton();
      r.generate.expectHUDLoading(false);
    });
  });

// TODO complete this.
}
