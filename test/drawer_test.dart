import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:first_app/models/appstate.dart';
import 'package:first_app/generated/l10n.dart';
import 'package:first_app/ui/theme/style.dart';
import 'package:first_app/ui/pages/home/drawer.dart';

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
        child: new HomePageDrawer(),
      ),
    ),
  );
}

void main() async {
  AppStateModel loginState;
  // We need mock initial values for SharedPreferences
  SharedPreferences.setMockInitialValues({});
  var prefs = await SharedPreferences.getInstance();
  loginState = AppStateModel(prefs);

  // Ensure we have a logged in state before testing HomePage as LoginPage() is rendered if
  // we are not authenticated
  // The state logic is based on receiving the access token, but does not validate the format
  loginState.logIn({'access_token': '123'});

  testWidgets('is drawer ready', (WidgetTester tester) async {
    await initWidget(tester, loginState);
    await tester.pump();

    expect(loginState.authenticated, true);
    // We should have opened the drawer
    expect(find.byType(HomePageDrawer), findsOneWidget);
    expect(find.byKey(Key("DrawerMenu_Header")), findsOneWidget);
    expect(find.byKey(Key("DrawerMenuTile_RefreshTokens")), findsOneWidget);
    expect(find.byKey(Key("DrawerMenuTile_GetUserInfo")), findsOneWidget);
    expect(find.byKey(Key("DrawerMenuTile_Localisation")), findsOneWidget);
  });

  testWidgets('log out from drawer', (WidgetTester tester) async {
    await initWidget(tester, loginState);
    await tester.pump();

    final buttonFinder = find.descendant(
        of: find.byType(HomePageDrawer),
        matching: find.byKey(Key("DrawerMenuTile_LogOut")));
    await tester.tap(buttonFinder);
    await tester.pump();
    // Authenticated state should be false
    expect(loginState.authenticated, false);
  });
}
