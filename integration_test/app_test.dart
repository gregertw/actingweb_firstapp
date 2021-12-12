import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:first_app/firebase_options.dart';

// The application under test.
import 'package:first_app/app.dart';

void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
  };
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  group('first_app', () {
    // First, define the Finders and use them to locate widgets from the
    // test suite. Note: the Strings provided to the `byValueKey` method must
    // be the same as the Strings we used for the Keys.
    final loginButtonFinder =
        find.byKey(const Key('LoginPage_LoginButton_Github'));
    final startListeningButtonFinder =
        find.byKey(const Key('LocationPage_StartListeningButton'));
    final locationTileFinder =
        find.byKey(const Key('LocationPage_LocationTile'));
    final mapToggleButton = find.byKey(const Key('OverlayMap_ToggleButton'));
    final mapOverlayFinder = find.byType(GoogleMap);
    final openDrawerMenuButton = find.byTooltip("Open navigation menu");
    final exitButtonFinder = find.byKey(const Key('DrawerMenuTile_LogOut'));

    testWidgets('app test', (tester) async {
      var app = await getApp(mock: true);
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();
      await tester.tap(loginButtonFinder);
      await tester.pumpAndSettle();
      await tester.tap(startListeningButtonFinder);
      await tester.pumpAndSettle();
      expect(locationTileFinder, findsWidgets);
      await tester.tap(startListeningButtonFinder);
      await tester.pumpAndSettle();
      expect(locationTileFinder, findsWidgets);
      await tester.tap(mapToggleButton);
      await tester.pumpAndSettle();
      expect(mapOverlayFinder, findsOneWidget);
      await tester.tap(mapToggleButton);
      await tester.pumpAndSettle();
      expect(mapOverlayFinder, findsNothing);
      await tester.tap(openDrawerMenuButton);
      await tester.pumpAndSettle();
      expect(exitButtonFinder, findsOneWidget);
      await tester.tap(exitButtonFinder);
      await tester.pumpAndSettle();
      expect(loginButtonFinder, findsOneWidget);
    });
  }); // group('first_app')
}
