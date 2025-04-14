import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../test/robot.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() => WidgetController.hitTestWarningShouldBeFatal = true);

  testWidgets('Registering and Signing-in', (tester) async {
    // * Note: All tests are wrapped with `runAsync` to prevent this error:
    // * A Timer is still pending even after the widget tree was disposed.
    await tester.runAsync(() async {
      final r = Robot(tester);
      await r.pumpApp(isIntegration: true);
      await r.home.tapGenerateGatoButton();
      await r.auth.registerAndSignIn();
      await r.tapBackButton();
      r.home.expectProfileIconButton();
    });
  });
}
