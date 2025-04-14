import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gato_id_generator/src/presentation/_common_widgets/custom_appbar.dart';
import 'package:gato_id_generator/src/presentation/auth/sign_in/view/email_password_sign_in_form_type.dart';
import 'package:gato_id_generator/src/presentation/auth/sign_in/view/sign_in_screen.dart';
import 'package:gato_id_generator/src/presentation/generate/view/generate_screen.dart';
import 'package:gato_id_generator/src/util/delay.dart';

@visibleForTesting
class AuthRobot {
  const AuthRobot(this.tester);
  final WidgetTester tester;

  Future<void> registerAndSignIn() async {
    expectFormTypeIs(EmailPasswordSignInFormType.signIn);

    // Enters register mode
    await tapSwitchButton();
    expectFormTypeIs(EmailPasswordSignInFormType.register);
    // Registering
    await enterEmailField("1233@123001.co");
    await enterPasswordField("12345678");
    await tapConfirmButton();
    // Wait for a moment.
    for (int i = 0; i < 5; i++) {
      await delay(true);
      await tester.pump(Duration(seconds: 1));
    }

    // Rdirected to sign-in mode
    expectFormTypeIs(EmailPasswordSignInFormType.signIn);
    // Signing-in
    await enterEmailField("1233@123001.co");
    await enterPasswordField("12345678");
    await tapConfirmButton();
    // Wait for a moment.
    for (int i = 0; i < 5; i++) {
      await delay(true);
      await tester.pump(Duration(seconds: 1));
    }

    expect(find.byType(EmailPasswordSignInScreen), findsNothing);
    expect(find.byType(GenerateScreen), findsOneWidget);
  }

  Future<void> expectInitialSignInLayoutIsCorrect() async {
    expectAppbar();
    expectBackIconButton();
    expectEmailField();
    expectPasswordField();
    expectSwitchButton();
    expectConfirmButton();
  }

  void expectAppbar() async {
    final finder = find.byType(CustomAppBar);
    expect(finder, findsOneWidget);
  }

  void expectBackIconButton() async {
    final finder = find.byType(BackIconButton);
    expect(finder, findsOneWidget);
  }

  Finder expectEmailField() {
    final finder = find.byKey(EmailPasswordSignInScreen.emailKey);
    expect(finder, findsOneWidget);
    return finder;
  }

  Future<void> enterEmailField(String text) async {
    await tester.enterText(expectEmailField(), text);
    await tester.pumpAndSettle();
  }

  Finder expectPasswordField() {
    final finder = find.byKey(EmailPasswordSignInScreen.passwordKey);
    expect(finder, findsOneWidget);
    return finder;
  }

  Future<void> enterPasswordField(String text) async {
    await tester.enterText(expectPasswordField(), text);
    await tester.pumpAndSettle();
  }

  Finder expectSwitchButton() {
    final finder = find.byKey(EmailPasswordSignInScreen.switchFormKey);
    expect(finder, findsOneWidget);
    return finder;
  }

  Future<void> tapSwitchButton() async {
    await tester.tap(expectSwitchButton());
    await tester.pumpAndSettle();
  }

  Finder expectConfirmButton() {
    final finder = find.byKey(EmailPasswordSignInScreen.confirmButtonKey);
    expect(finder, findsOneWidget);
    return finder;
  }

  Future<void> tapConfirmButton() async {
    await tester.tap(expectConfirmButton());
  }

  void expectFormTypeIs(EmailPasswordSignInFormType type) {
    final finder = find.text(type.primaryButtonText);
    expect(finder, findsOneWidget);
  }
}
