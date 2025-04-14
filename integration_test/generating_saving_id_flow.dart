import 'package:flutter_test/flutter_test.dart';
import 'package:gato_id_generator/src/util/delay.dart';
import 'package:integration_test/integration_test.dart';

import '../test/robot.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() => WidgetController.hitTestWarningShouldBeFatal = true);

  testWidgets('''
    Given signed-in,
    When generating id, 
    Then can save id after finish generating,
    And result should exists in history.
  ''', (tester) async {
    // * Note: All tests are wrapped with `runAsync` to prevent this error:
    // * A Timer is still pending even after the widget tree was disposed.
    await tester.runAsync(() async {
      final r = Robot(tester);
      await r.pumpApp(isIntegration: true);
      await r.home.tapGenerateGatoButton();
      await r.auth.registerAndSignIn();

      await r.generate.expectInitialLayoutIsCorrect();
      await r.generate.tapGenerateButton();
      r.generate.expectHUDLoading(true);
      for (int i = 0; i < 5; i++) {
        await delay(true);
        await tester.pump(Duration(seconds: 1));
      }

      r.generate.expectCachedNetworkImages();
      await r.generate.tapSaveGeneratedButton();
      for (int i = 0; i < 5; i++) {
        await delay(true);
        await tester.pump(Duration(seconds: 1));
      }

      r.generate.expectGeneratedIdsCount(1);
    });
  });
}
