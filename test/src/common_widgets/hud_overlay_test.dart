import 'package:gato_id_generator/src/presentation/_common_widgets/hud_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('HUD shows background and loading indicator', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // * Arrange
      forceShowHUD = true;
      await tester.pumpWidget(
        ProviderScope(
          child: const MaterialApp(home: HudOverlay(child: Scaffold())),
        ),
      );

      for (int i = 0; i < 5; i++) {
        // because pumpAndSettle doesn't work with riverpod
        await tester.pump(Duration(seconds: 1));
      }

      expect(find.byKey(HudOverlay.bgHudKey), findsOneWidget);
      expect(find.byKey(HudOverlay.loadingHudKey), findsOneWidget);
    });
  });
}
