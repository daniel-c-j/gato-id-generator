import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:gato_id_generator/src/core/_core.dart';
import 'package:gato_id_generator/src/presentation/auth/sign_in/view/email_password_sign_in_form_type.dart';
import 'package:gato_id_generator/src/presentation/auth/sign_in/view/sign_in_screen.dart';
import 'package:gato_id_generator/src/presentation/generate/view/generate_screen.dart';
import 'package:gato_id_generator/src/util/delay.dart';

import '../../../../../robot.dart';

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

  testWidgets('SignInScreen layout is correct.', (tester) async {
    await tester.runAsync(() async {
      final r = Robot(tester);
      await r.pumpApp();

      await r.home.tapGenerateGatoButton();
      await r.auth.expectInitialSignInLayoutIsCorrect();
    });
  });

  testWidgets('SignInScreen form can be switched.', (tester) async {
    await tester.runAsync(() async {
      final r = Robot(tester);
      await r.pumpApp();

      // Initial
      await r.home.tapGenerateGatoButton();
      r.auth.expectFormTypeIs(EmailPasswordSignInFormType.signIn);

      await r.auth.tapSwitchButton();
      r.auth.expectFormTypeIs(EmailPasswordSignInFormType.register);

      await r.auth.tapSwitchButton();
      r.auth.expectFormTypeIs(EmailPasswordSignInFormType.signIn);
    });
  });

  testWidgets('SignInScreen form can be entered and confirmed.', (tester) async {
    await tester.runAsync(() async {
      final r = Robot(tester);
      await r.pumpApp();

      // Init
      await r.home.tapGenerateGatoButton();
      r.auth.expectFormTypeIs(EmailPasswordSignInFormType.signIn);
      // Tries to sign-in
      await r.auth.enterEmailField("Manul@gato.id");
      await r.auth.enterPasswordField("secretManul");
      await r.auth.tapConfirmButton();
      for (int i = 0; i < 5; i++) {
        await tester.pump(Duration(seconds: 1));
      }
      r.expectSnackBar();
    });
  });

  testWidgets('''
      Given SignInScreen, and has no account yet,
      When registering and signing in,
      Then screen redirects to GenerateScreen.
    ''', (tester) async {
    await tester.runAsync(() async {
      final r = Robot(tester);
      await r.pumpApp();

      // Init
      await r.home.tapGenerateGatoButton();
      r.auth.expectFormTypeIs(EmailPasswordSignInFormType.signIn);

      // Enters register mode
      await r.auth.tapSwitchButton();
      r.auth.expectFormTypeIs(EmailPasswordSignInFormType.register);
      // Registering
      await r.auth.enterEmailField("1233@123001.co");
      await r.auth.enterPasswordField("12345678");
      await r.auth.tapConfirmButton();
      // Wait for a moment.
      for (int i = 0; i < 5; i++) {
        await delay(true);
        await tester.pump(Duration(seconds: 1));
      }

      // Rdirected to sign-in mode
      r.auth.expectFormTypeIs(EmailPasswordSignInFormType.signIn);
      // Signing-in
      await r.auth.enterEmailField("1233@123001.co");
      await r.auth.enterPasswordField("12345678");
      await r.auth.tapConfirmButton();
      // Wait for a moment.
      for (int i = 0; i < 5; i++) {
        await delay(true);
        await tester.pump(Duration(seconds: 1));
      }

      expect(find.byType(EmailPasswordSignInScreen), findsNothing);
      expect(find.byType(GenerateScreen), findsOneWidget);
    });
  });
}
