import 'package:gato_id_generator/src/data/model/version_check.dart';
import 'package:gato_id_generator/src/presentation/version_check/view/version_update_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:version/version.dart';

void main() {
  VersionCheck mockVersionCheckNotRequired() => VersionCheck(
        latestVersion: Version(1, 0, 0),
        canUpdate: true,
        mustUpdate: false,
        requiredToUpdateVer: Version(0, 1, 0, preRelease: ["alpha"]),
      );

  VersionCheck mockVersionCheckIsRequired() => VersionCheck(
        latestVersion: Version(1, 0, 0),
        canUpdate: true,
        mustUpdate: true,
        requiredToUpdateVer: Version(2, 0, 0, preRelease: ["alpha"]),
      );

  testWidgets('VersionUpdateDialog displays correct information when update IS NOT required.',
      (WidgetTester tester) async {
    // * Arrange
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(builder: (context) {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(content: VersionUpdateDialog(mockVersionCheckNotRequired()));
                },
              );
            });
            return const SizedBox.shrink();
          }),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // * Act
    final updateTextFinder = find.text("New update v1.0.0 "); // TODO use keys.
    final descriptionTextFinder = find.text("There is a new improved version of this app.");
    final downloadButtonFinder = find.text("Download");
    final laterButtonFinder = find.text("No thanks");

    // * Assert
    expect(updateTextFinder, findsOneWidget);
    expect(descriptionTextFinder, findsOneWidget);
    expect(downloadButtonFinder, findsOneWidget);
    expect(laterButtonFinder, findsOneWidget);
  });

  testWidgets('VersionUpdateDialog displays correct information when update IS required.',
      (WidgetTester tester) async {
    // * Arrange
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(builder: (context) {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(content: VersionUpdateDialog(mockVersionCheckIsRequired()));
                },
              );
            });
            return const SizedBox.shrink();
          }),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // * Act
    final updateTextFinder = find.text("New update v1.0.0 is required"); // TODO use keys.
    final descriptionTextFinder = find.text("There is a new improved version of this app.");
    final downloadButtonFinder = find.text("Download");
    final laterButtonFinder = find.text("No thanks");

    // * Assert
    expect(updateTextFinder, findsOneWidget);
    expect(descriptionTextFinder, findsOneWidget);
    expect(downloadButtonFinder, findsOneWidget);
    expect(laterButtonFinder, findsOneWidget);
  });

  // TODO test launchUrl

  testWidgets('Later button close the dialog.', (WidgetTester tester) async {
    // * Arrange
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(builder: (context) {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(content: VersionUpdateDialog(mockVersionCheckIsRequired()));
                },
              );
            });
            return const SizedBox.shrink();
          }),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // * Act
    final laterTextFinder = find.text("No thanks"); // TODO use keys.
    await tester.tap(laterTextFinder);
    await tester.pumpAndSettle();

    // * Assert
    expect(find.byType(VersionUpdateDialog), findsNothing);
  });
}
