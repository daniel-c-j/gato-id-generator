import 'dart:io';
import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:gato_id_generator/src/app.dart';
import 'package:gato_id_generator/src/core/_core.dart';

import '../robot.dart';

void main() {
  setUp(() async {
    try {
      await Directory('temp').delete(recursive: true);
      getIt.reset(dispose: true);
    } catch (e) {
      // print("ERROR");
      // print(e);
    }
  });

  final sizeVariant = ValueVariant<Size>({
    const Size(300, 600),
    const Size(600, 800),
    const Size(1000, 1000),
  });

  testWidgets(
    'Golden - HomeScreen',
    (tester) async {
      final r = Robot(tester);
      final currentSize = sizeVariant.currentValue!;
      await r.golden.setSurfaceSize(currentSize);
      await r.golden.loadTextFont();
      await r.golden.loadMaterialIconFont();
      await tester.runAsync(() async => await r.pumpApp());
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
    skip: false,
  );
}
