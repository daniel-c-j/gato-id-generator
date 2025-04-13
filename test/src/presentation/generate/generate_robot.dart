import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gato_id_generator/src/presentation/_common_widgets/custom_appbar.dart';
import 'package:gato_id_generator/src/presentation/_common_widgets/hud_overlay.dart';
import 'package:gato_id_generator/src/presentation/generate/view/components/generate_button.dart';
import 'package:gato_id_generator/src/presentation/generate/view/components/generated_history.dart';
import 'package:gato_id_generator/src/presentation/generate/view/components/id/gato_id_card.dart';

@visibleForTesting
class GenerateRobot {
  const GenerateRobot(this.tester);
  final WidgetTester tester;

  Future<void> expectInitialLayoutIsCorrect() async {
    expectAppbar();
    expectBackIconButton();
    expectGatoIdCardWidget();
    expectNoCachedNetworkImage();
    expectSaveGeneratedButton();
    expectGenerateButton();
    expectGeneratedHistory();
    expectGeneratedIdsCount(0);
  }

  void expectAppbar() async {
    final finder = find.byType(CustomAppBar);
    expect(finder, findsOneWidget);
  }

  void expectBackIconButton() async {
    final finder = find.byType(BackIconButton);
    expect(finder, findsOneWidget);
  }

  void expectGatoIdCardWidget() async {
    final finder = find.byType(GatoIdCard);
    expect(finder, findsOneWidget);
  }

  void expectNoCachedNetworkImage() async {
    final finder = find.byType(CachedNetworkImage);
    expect(finder, findsNothing);
  }

  Finder expectSaveGeneratedButton() {
    final finder = find.byType(SaveGeneratedButton);
    expect(finder, findsOneWidget);
    return finder;
  }

  Future<void> tapSaveGeneratedButton() async {
    await tester.tap(expectSaveGeneratedButton());
    await tester.pumpAndSettle();
  }

  Finder expectGenerateButton() {
    final finder = find.byType(GenerateButton);
    expect(finder, findsOneWidget);
    return finder;
  }

  Future<void> tapGenerateButton() async {
    await tester.tap(expectGenerateButton());
    await tester.pumpAndSettle();
  }

  Finder expectGeneratedHistory() {
    final finder = find.byType(GeneratedHistory);
    expect(finder, findsOneWidget);
    return finder;
  }

  Finder expectGeneratedIdsCount(int val) {
    final finder = find.text("Generated IDs ($val)");
    expect(finder, findsOneWidget);
    return finder;
  }

  void expectHUDLoading(int val) {
    expect(find.byKey(HudOverlay.bgHudKey), findsOneWidget);
    expect(find.byKey(HudOverlay.loadingHudKey), findsOneWidget);
  }
}
