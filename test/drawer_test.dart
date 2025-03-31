import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:first_app/models/appstate.dart';
import 'package:first_app/l10n/app_localizations.dart';
import 'package:first_app/ui/theme/style.dart';
import 'package:first_app/ui/pages/home/drawer.dart';

// Helper function to encapsulate code needed to instantiate the HomePage() widget
dynamic initWidget(WidgetTester tester, AppStateModel state) {
  return tester.pumpWidget(
    MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      theme: appTheme,
      home: ChangeNotifierProvider.value(
        value: state,
        child: const HomePageDrawer(),
      ),
    ),
  );
}

void main() async {
  AppStateModel loginState;
  // We need mock initial values for SharedPreferences
  SharedPreferences.setMockInitialValues({});
  var prefs = await SharedPreferences.getInstance();
  loginState = AppStateModel(prefs: prefs, mock: true);

  testWidgets('is drawer ready', (WidgetTester tester) async {
    await initWidget(tester, loginState);
    await tester.pump();
    await loginState.authorize();
    expect(loginState.authenticated, true);
    // We should have opened the drawer
    expect(find.byType(HomePageDrawer), findsOneWidget);
    expect(find.byKey(const Key("DrawerMenu_Header")), findsOneWidget);
    expect(
        find.byKey(const Key("DrawerMenuTile_RefreshTokens")), findsOneWidget);
    expect(find.byKey(const Key("DrawerMenuTile_GetUserInfo")), findsOneWidget);
    expect(
        find.byKey(const Key("DrawerMenuTile_Localisation")), findsOneWidget);
  });

  testWidgets('log out from drawer', (WidgetTester tester) async {
    await initWidget(tester, loginState);
    await tester.pump();

    final buttonFinder = find.descendant(
        of: find.byType(HomePageDrawer),
        matching: find.byKey(const Key("DrawerMenuTile_LogOut")));
    await tester.tap(buttonFinder);
    await tester.pump();
    // Authenticated state should be false
    expect(loginState.authenticated, false);
  });
}
