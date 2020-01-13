import 'package:flutter_driver/driver_extension.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:first_app/generated/i18n.dart';
import 'package:first_app/models/appstate.dart';
import 'package:first_app/ui/pages/home/index.dart';
import 'package:first_app/ui/pages/login/index.dart';
import 'package:first_app/providers/auth.dart';
import 'package:first_app/ui/theme/style.dart';
import 'package:first_app/mock/mock_webauth.dart';

void main() async {

  AppStateModel appState;

  // ignore: missing_return
  Future<String> dataHandler(String msg) async {
    switch (msg) {
      case "mockLogin":
        {
          appState.mocks.enableMock('authClient', new MockWebAuth());
        }
        break;
      case "clearMocks":
        {
          appState.mocks.clearMocks();
        }
        break;
      case "clearSession":
        {
          // Use the real Auth0Client to get rid of any logon state
          Auth0Client().closeSessions();
        }
        break;
      default:
        break;
    }
  }

  // This line enables the extension.
  enableFlutterDriverExtension(handler: dataHandler);

  // Get an instance so that globals are initialised
  var prefs = await SharedPreferences.getInstance();
  // We don't want any state we cannot control when testing
  prefs.clear();
  // Let's initialise the app state with the stored preferences
  appState = new AppStateModel(prefs);
  // Use the real Auth0Client to get rid of any logon state
  // First time on a hot restart of observervatory, this will result in an attempted
  // login, so hot restart (R) needs to be done twice.
  Auth0Client().closeSessions();

  runApp(
    new MaterialApp(
      onGenerateTitle: (context) => S.of(context).appTitle,
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      localeResolutionCallback:
          S.delegate.resolution(fallback: new Locale("en", "")),
      home: new ScopedModel<AppStateModel>(
        model: appState,
        child: new HomePage(),
      ),
      theme: appTheme,
      routes: <String, WidgetBuilder>{
        "/HomePage": (BuildContext context) => new ScopedModel<AppStateModel>(
              model: appState,
              child: new HomePage(),
            ),
        "/LoginPage": (BuildContext context) => new ScopedModel<AppStateModel>(
              model: appState,
              child: new LoginPage(),
            ),
      },
    ),
  );
}
