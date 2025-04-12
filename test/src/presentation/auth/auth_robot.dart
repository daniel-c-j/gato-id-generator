import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gato_id_generator/src/presentation/_common_widgets/custom_appbar.dart';
import 'package:gato_id_generator/src/presentation/auth/sign_in/view/email_password_sign_in_form_type.dart';
import 'package:gato_id_generator/src/presentation/auth/sign_in/view/sign_in_screen.dart';

@visibleForTesting
class AuthRobot {
  const AuthRobot(this.tester);
  final WidgetTester tester;

  Future<void> expectInitialSignInLayoutIsCorrect() async {
    expectAppbar();
    expectEmailField();
    expectPasswordField();
    expectSwitchButton();
    expectConfirmButton();
  }

  void expectAppbar() async {
    final finder = find.byType(CustomAppBar);
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
    await tester.tap(expectConfirmButton(), warnIfMissed: false);
  }

  Finder expectSnackBar() {
    final finder = find.byType(SnackBar);
    expect(finder, findsOneWidget);
    return finder;
  }

  void expectFormTypeIs(EmailPasswordSignInFormType type) {
    final finder = find.text(type.primaryButtonText);
    expect(finder, findsOneWidget);
  }
}
