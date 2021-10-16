import 'package:first_app/ui/widgets/anchored_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:geolocator/geolocator.dart';
import 'package:first_app/ui/pages/map/index.dart';
import 'package:first_app/models/locstate.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:first_app/ui/theme/style.dart';
import 'package:first_app/mock/mock_geolocator.dart';

// Helper function to encapsulate code needed to instantiate the HomePage() widget
dynamic initWidget(WidgetTester tester, LocStateModel state) {
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
        child: const OverlayMapPage(),
      ),
    ),
  );
}

void main() async {
  // Since locstate tries to find a placemark and thus uses geolocation, which again uses
  // underlying system, we need to make sure everything is initialised
  TestWidgetsFlutterBinding.ensureInitialized();

  var state = LocStateModel(MockGeolocator());
  // Test location Oslo, Norway
  state.addLocation(Position(
      latitude: 59.893777,
      longitude: 10.7150951,
      speed: 0.0,
      accuracy: 0.0,
      speedAccuracy: 0.0,
      altitude: 0.0,
      heading: 0.0,
      timestamp: DateTime.now()));
  testWidgets('OverlayMapPage', (WidgetTester tester) async {
    await initWidget(tester, state);
    await tester.pump();
    expect(find.byType(FloatingActionButton), findsOneWidget);
    expect(find.byType(AnchoredOverlay), findsOneWidget);
    expect(find.byType(OverlayBuilder), findsOneWidget);
  });
}
