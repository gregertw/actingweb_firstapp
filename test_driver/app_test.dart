import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('first_app', () {
    // First, define the Finders and use them to locate widgets from the
    // test suite. Note: the Strings provided to the `byValueKey` method must
    // be the same as the Strings we used for the Keys.
    final loginButtonFinder = find.byValueKey('LoginPage_LoginButton');
    final exitButtonFinder = find.byValueKey('HomePage_ExitButton');
    final startListeningButtonFinder = find.byValueKey('LocationPage_StartListeningButton');
    final locationTileFinder = find.byValueKey('LocationPage_LocationTile');

    FlutterDriver driver;

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await FlutterDriver.connect();
      // Clear any earlier mocks
      driver.requestData('clearMocks');
      // Clear any actual logged in sessions
      driver.requestData('clearSessions');
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
      // Push exit button if it's there to log us out
      await driver
          .tap(exitButtonFinder, timeout: Duration(milliseconds: 200))
          .catchError((e) {});
      // We should now have a login button
      await driver.waitFor(loginButtonFinder);
      driver.requestData('mockLogin');
      driver.requestData('mockGeo');
      // Then, tap the login button.
      await driver.tap(loginButtonFinder);
      await driver.waitFor(exitButtonFinder);
      await driver.tap(startListeningButtonFinder);
      await driver.waitFor(locationTileFinder);
    });
  }); // group('first_app')
}
