import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:gato_id_generator/src/app.dart';
import 'package:integration_test/integration_test.dart';

import '../robot.dart';

void main() {
  final sizeVariant = ValueVariant<Size>({
    const Size(300, 600),
    const Size(600, 800),
    const Size(1000, 1000),
  });

  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'Golden - HomeScreen',
    (tester) async {
      final r = Robot(tester);
      final currentSize = sizeVariant.currentValue!;
      await r.golden.setSurfaceSize(currentSize);
      await r.golden.loadTextFont();
      await r.golden.loadMaterialIconFont();
      await r.golden.loadBoxIconFont();
      await r.pumpApp();
      await r.golden.precacheImages();
      await expectLater(
        find.byType(App),
        matchesGoldenFile(
          'homescreen_${currentSize.width.toInt()}x${currentSize.height.toInt()}.png',
        ),
      );
    },
    variant: sizeVariant,
    tags: ['golden'],
    // TODO Skip this test until we can run it successfully on CI without this error:
    // Golden "products_list_300x600.png": Pixel test failed, 2.33% diff detected.
    skip: false,
  );
}
