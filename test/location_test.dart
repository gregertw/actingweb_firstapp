import 'package:first_app/models/locstate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:first_app/ui/pages/location/index.dart';
import 'package:first_app/mock/mock_geolocator.dart';
import 'package:first_app/generated/l10n.dart';
import 'package:first_app/ui/theme/style.dart';

// Helper function to encapsulate code needed to instantiate the HomePage() widget
dynamic initWidget(WidgetTester tester, LocStateModel locstate) {
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
      home: Scaffold(
        appBar: AppBar(),
        body: ChangeNotifierProvider.value(
          value: locstate,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                LocationStreamWidget(),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

void main() async {
  LocStateModel state;
  state = LocStateModel(MockGeolocator());
  testWidgets('LocationPage', (WidgetTester tester) async {
    await initWidget(tester, state);
    await tester.pump();
    expect(find.byType(LocationStreamWidget), findsOneWidget);
    // Wait for button to appear
    await tester.pump(Duration(seconds: 1));
    expect(find.byType(ListTile), findsOneWidget);
    expect(
        find.descendant(
            of: find.byType(LocationStreamWidget),
            matching: find.byType(PositionListItem)),
        findsNothing);
    // Find Start listening button
    var finder = find.descendant(
        of: find.byType(LocationStreamWidget),
        matching: find.byType(ElevatedButton));
    await tester.tap(finder);
    expect(find.byType(ListView), findsOneWidget);
    // Wait for locations to appear from geolocator mock
    await tester.pump(Duration(seconds: 20));
    // Even when specifying offstage widgets in find, only five are found,
    // although mock geolocator generates 10
    expect(
        find.descendant(
            of: find.byType(LocationStreamWidget),
            matching: find.byType(PositionListItem)),
        findsNWidgets(5));
    expect(
        find.descendant(
            of: find.byType(LocationStreamWidget),
            matching: find.text('Lonesome town,  , , Norway')),
        findsNWidgets(5));
  });
}
