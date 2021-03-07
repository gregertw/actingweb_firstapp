import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:first_app/ui/pages/login/index.dart';
import 'package:first_app/models/appstate.dart';
import 'package:first_app/generated/l10n.dart';
import 'package:first_app/ui/theme/style.dart';

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
        child: new LoginPage(),
      ),
    ),
  );
}

void main() async {
  AppStateModel state;
  // We need mock initial values for SharedPreferences
  SharedPreferences.setMockInitialValues({});
  var prefs = await SharedPreferences.getInstance();
  // We have one logged in state and one logged out, to be used with various tests
  state = AppStateModel(prefs);
  testWidgets('LoginPage', (WidgetTester tester) async {
    await initWidget(tester, state);

    await tester.pump();
    expect(find.byType(Image), findsOneWidget);
    expect(find.byType(Text), findsNWidgets(2));
    expect(find.byType(AuthPage), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
    // Here we could tap the button, but it only triggers
    // a webpage with login from auth0, so we cannot test that in a widget test
  });
}
