import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:first_app/ui/pages/home/index.dart';
import 'package:first_app/models/appstate.dart';
import 'package:first_app/generated/i18n.dart';
import 'package:first_app/ui/theme/style.dart';
import 'package:first_app/ui/pages/location/index.dart';
import 'package:first_app/ui/pages/map/index.dart';
import 'package:first_app/ui/pages/login/index.dart';

// Helper function to encapsulate code needed to instantiate the HomePage() widget
dynamic initWidget(WidgetTester tester, AppStateModel state) {
  return tester.pumpWidget(
        new MaterialApp(
          onGenerateTitle: (context) => S.of(context).appTitle,
          localizationsDelegates: [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          localeResolutionCallback: S.delegate.resolution(fallback: new Locale("en", "")),
          theme: appTheme,
          home: new ScopedModel<AppStateModel>(
              model: state,
              child: new HomePage()
          )
        )
      );
}

void main() async {
  AppStateModel loginState, logoutState;
  // We need mock initial values for SharedPreferences
  SharedPreferences.setMockInitialValues({});
  var prefs = await SharedPreferences.getInstance();
  // We have one logged in state and one logged out, to be used with various tests
  loginState = AppStateModel(prefs);
  logoutState = AppStateModel(prefs);

  // Ensure we have a logged in state before testing HomePage as LoginPage() is rendered if
  // we are not authenticated
  // The state logic is based on receiving the access token, but does not validate the format
  loginState.logIn({'access_token': '123'});

  test('logged in state', () {
    expect(loginState.authenticated, true);
  });

  testWidgets('logged-out homepage widget', (WidgetTester tester) async {
    await initWidget(tester, logoutState);
    expect(find.byType(LoginPage), findsOneWidget);
  });
  
  testWidgets('logged-in homepage widget', (WidgetTester tester) async {
    await initWidget(tester, loginState);
  
    // We should find both the map toggle button and the log out button
    expect(find.byType(FloatingActionButton), findsNWidgets(2));
    expect(find.byType(LocationStreamWidget), findsOneWidget);
    expect(find.byType(OverlayMapPage), findsOneWidget);
  });

testWidgets('log out of homepage widget', (WidgetTester tester) async {
    await initWidget(tester, loginState);
  
    // Find the log out button
    final finder = find.descendant(
      of: find.byType(Scaffold),
      matching: find.byIcon(Icons.exit_to_app)
      );
    // and tap it to log out
    await tester.tap(finder);
    await tester.pump();

    // We should be back to the LoginPage
    expect(find.byType(LoginPage), findsOneWidget);
    // And authenticated state should be false
    expect(loginState.authenticated, false);
    
  });
}