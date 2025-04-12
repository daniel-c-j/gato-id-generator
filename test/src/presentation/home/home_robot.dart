import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gato_id_generator/src/presentation/_common_widgets/custom_appbar.dart';
import 'package:gato_id_generator/src/presentation/about/components/about_icon_button.dart';
import 'package:gato_id_generator/src/presentation/auth/account/view/components/profile_icon_button.dart';
import 'package:gato_id_generator/src/presentation/home/view/components/theme_icon_button.dart';
import 'package:gato_id_generator/src/presentation/home/view/home_screen.dart';

// TODO extends more. findByType image for example.

@visibleForTesting
class HomeRobot {
  const HomeRobot(this.tester);
  final WidgetTester tester;

  Future<void> expectInitialLayoutIsCorrect() async {
    expectAppbar();
    expectThemeIconButton();
    expectAboutIconButton();
    expectMottoText();
    expectCardIdPreviews();
    expectGenerateGatoButton();
    expectGenerateDogButton();
  }

  void expectAppbar() async {
    final finder = find.byType(CustomAppBar);
    expect(finder, findsOneWidget);
  }

  Finder expectThemeIconButton() {
    final finder = find.byType(ThemeIconButton);
    expect(finder, findsOneWidget);
    return finder;
  }

  Future<void> tapThemeIconButton() async {
    await tester.tap(expectThemeIconButton());
  }

  Finder expectAboutIconButton() {
    final finder = find.byKey(AboutIconButton.buttonKey);
    expect(finder, findsOneWidget);
    return finder;
  }

  Future<void> tapAboutIconButton() async {
    await tester.tap(expectAboutIconButton());
    await tester.pumpAndSettle();
  }

  Finder expectProfileIconButton() {
    final finder = find.byType(ProfileIconButton);
    expect(finder, findsOneWidget);
    return finder;
  }

  Future<void> tapProfileIconButton() async {
    await tester.tap(expectProfileIconButton());
    await tester.pumpAndSettle();
  }

  Finder expectMottoText() {
    final finder = find.byKey(HomeScreen.mottoKey);
    expect(finder, findsOneWidget);
    return finder;
  }

  Finder expectCardIdPreviews() {
    final finder = find.byType(GatoLine);
    expect(finder, findsNWidgets(3));
    return finder;
  }

  Finder expectGenerateGatoButton() {
    final finder = find.byKey(HomeScreen.gatoKey);
    expect(finder, findsOneWidget);
    return finder;
  }

  Future<void> tapGenerateGatoButton() async {
    await tester.tap(expectGenerateGatoButton());
    await tester.pumpAndSettle();
  }

  Finder expectGenerateDogButton() {
    final finder = find.byKey(HomeScreen.dogKey);
    expect(finder, findsOneWidget);
    return finder;
  }

  Future<void> tapGenerateDogButton() async {
    await tester.tap(expectGenerateDogButton());
    await tester.pumpAndSettle();
  }
}
