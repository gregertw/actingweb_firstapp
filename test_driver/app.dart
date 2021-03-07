import 'package:flutter_driver/driver_extension.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:first_app/generated/l10n.dart';
import 'package:first_app/models/appstate.dart';
import 'package:first_app/ui/pages/home/index.dart';
import 'package:first_app/ui/pages/login/index.dart';
import 'package:first_app/ui/theme/style.dart';
import 'package:first_app/mock/mock_appauth.dart';
import 'package:first_app/mock/mock_geolocator.dart';

void main() async {
  // Get an empty AppState
  AppStateModel appState = new AppStateModel();

  // ignore: missing_return
  Future<String> dataHandler(String msg) async {
    print("Got driver message: $msg");
    switch (msg) {
      case "mockLogin":
        {
          appState.mocks.enableMock('authClient', MockFlutterAppAuth());
        }
        break;
      case "mockGeo":
        {
          appState.mocks.enableMock('geolocator', MockGeolocator());
        }
        break;
      case "clearMocks":
        {
          appState.mocks.clearMocks();
        }
        break;
      case "clearSession":
        {
          appState.logOut();
        }
        break;
      default:
        throw ("Not a valid driver message!!");
        break;
    }
  }

  // This line enables the extension.
  enableFlutterDriverExtension(handler: dataHandler);

  // The driver does not like being enabled after the binding has been initialised,
  // so we need to do it here
  WidgetsFlutterBinding.ensureInitialized();

  // Get an instance so that globals are initialised
  var prefs = await SharedPreferences.getInstance();

  // We don't want any state we cannot control when testing
  prefs.clear();
  // Let's initialise the app state with the stored preferences
  appState.prefs = prefs;
  appState.setLocale(null);

  runApp(
    new MaterialApp(
      onGenerateTitle: (context) => S.of(context).appTitle,
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      home: new ChangeNotifierProvider.value(
        value: appState,
        child: new HomePage(),
      ),
      theme: appTheme,
      routes: <String, WidgetBuilder>{
        "/HomePage": (BuildContext context) => new ChangeNotifierProvider.value(
              value: appState,
              child: new HomePage(),
            ),
        "/LoginPage": (BuildContext context) =>
            new ChangeNotifierProvider.value(
              value: appState,
              child: new LoginPage(),
            ),
      },
    ),
  );
}
