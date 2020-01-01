import 'package:first_app/ui/widgets/anchored_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:first_app/ui/pages/map/index.dart';
import 'package:first_app/models/appstate.dart';
import 'package:first_app/generated/i18n.dart';
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
          localeResolutionCallback: S.delegate.resolution(fallback: new Locale("en", "")),
          theme: appTheme,
          home: new ScopedModel<AppStateModel>(
              model: state,
              child: new OverlayMapPage()
          )
        )
      );
}

void main() async {

  AppStateModel state;
  // We need mock initial values for SharedPreferences
  SharedPreferences.setMockInitialValues({});
  var prefs = await SharedPreferences.getInstance();
  // We have one logged in state and one logged out, to be used with various tests
  state = AppStateModel(prefs);
  // Test location Oslo, Norway
  state.setLocation(59.893777, 10.7150951);
  testWidgets('OverlayMapPage', (WidgetTester tester) async {
    await initWidget(tester, state);

    expect(find.byType(FloatingActionButton), findsOneWidget);
    expect(find.byType(AnchoredOverlay), findsOneWidget);
    expect(find.byType(OverlayBuilder), findsOneWidget);
  });

}
    