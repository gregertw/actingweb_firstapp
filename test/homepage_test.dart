import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:first_app/models/appstate.dart';
import 'package:first_app/generated/l10n.dart';
import 'package:first_app/ui/theme/style.dart';
import 'package:first_app/ui/pages/home/index.dart';
import 'package:first_app/ui/pages/home/drawer.dart';
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
      theme: appTheme,
      home: new ChangeNotifierProvider.value(
        value: state,
        child: new HomePage(),
      ),
    ),
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
    await tester.pump();
    expect(find.byType(LoginPage), findsOneWidget);
  });

  testWidgets('logged-in homepage widget', (WidgetTester tester) async {
    await initWidget(tester, loginState);
    await tester.pump();
    expect(find.byKey(Key("HomePage_Scaffold")), findsOneWidget);
    expect(find.byType(AppBar), findsOneWidget);
    // We should find the map toggle button
    expect(find.byType(FloatingActionButton), findsOneWidget);
    expect(find.byType(LocationStreamWidget), findsOneWidget);
    expect(find.byType(OverlayMapPage), findsOneWidget);
  });

  testWidgets('open drawer', (WidgetTester tester) async {
    await initWidget(tester, loginState);
    await tester.pump();
    // Find the menu button
    final finder = find.descendant(
        of: find.byKey(Key("HomePage_Scaffold")),
        matching: find.byTooltip("Open navigation menu"));
    // and tap it to open
    await tester.tap(finder);
    await tester.pump();

    // We should have opened the drawer
    expect(find.byType(HomePageDrawer), findsOneWidget);
    expect(
        find.descendant(
            of: find.byType(HomePageDrawer),
            matching: find.byType(UserAccountsDrawerHeader)),
        findsOneWidget);
    // Number of menu items
    expect(
        find.descendant(
            of: find.byType(HomePageDrawer), matching: find.byType(ListTile)),
        findsNWidgets(4));
  });
}
