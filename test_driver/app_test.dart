import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('first_app', () {
    // First, define the Finders and use them to locate widgets from the
    // test suite. Note: the Strings provided to the `byValueKey` method must
    // be the same as the Strings we used for the Keys.
    final loginButtonFinder = find.byValueKey('LoginPage_LoginButton');
    final startListeningButtonFinder =
        find.byValueKey('LocationPage_StartListeningButton');
    final locationTileFinder = find.byValueKey('LocationPage_LocationTile');
    final mapToggleButton = find.byValueKey('OverlayMap_ToggleButton');
    final mapOverlayFinder = find.byType('GoogleMap');
    final openDrawerMenuButton = find.byTooltip("Open navigation menu");
    final exitButtonFinder = find.byValueKey('DrawerMenuTile_LogOut');

    FlutterDriver driver;

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await FlutterDriver.connect();
      // Clear any earlier mocks
      driver.requestData('clearMocks');
      // Clear any actual logged in sessions
      driver.requestData('clearSession');
    });
    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test('check flutter driver health', () async {
      final health = await driver.checkHealth();
      expect(health.status, HealthStatus.ok);
    });

    test('logs in', () async {
      // Push exit button if it's there to log us out.
      // Commented it out as setupAll() now makes sure we are logged out.
      /*await driver
          .tap(exitButtonFinder, timeout: Duration(milliseconds: 200))
          .catchError((e) {});*/
      // We should now have a login button
      await driver.waitFor(loginButtonFinder);
      driver.requestData('mockLogin');
      driver.requestData('mockGeo');
      // Then, tap the login button.
      await driver.tap(loginButtonFinder);
      await driver.tap(startListeningButtonFinder);
      await driver.waitFor(locationTileFinder);
    });

    test('listen to location', () async {
      await driver.tap(startListeningButtonFinder);
      await driver.waitFor(locationTileFinder);
    });

    test('toggle map', () async {
      await driver.tap(mapToggleButton);
      await driver.waitFor(mapOverlayFinder);
      await driver.tap(mapToggleButton);
      await driver.waitForAbsent(mapOverlayFinder);
    });
    test('open drawer menu', () async {
      await driver.tap(openDrawerMenuButton);
      await driver.waitFor(exitButtonFinder);
    });
    test('log out', () async {
      await driver.tap(exitButtonFinder);
      await driver.waitFor(loginButtonFinder);
    });
  }); // group('first_app')
}
