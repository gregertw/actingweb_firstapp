import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'dart:async';
import 'generated/i18n.dart';
import 'models/appstate.dart';
import 'ui/pages/home/index.dart';
import 'ui/pages/login/index.dart';
import 'ui/theme/style.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  // A breaking change in the platform messaging, as of Flutter 1.12.13+hotfix.5,
  // we need to explicitly initialise bindings to get access to the BinaryMessenger
  // This is needed by Crashlytics.
  // https://groups.google.com/forum/#!msg/flutter-announce/sHAL2fBtJ1Y/mGjrKH3dEwAJ
  WidgetsFlutterBinding.ensureInitialized();

  // Set `enableInDevMode` to true to see reports while in debug mode
  // This is only to be used for confirming that reports are being
  // submitted as expected. It is not intended to be used for everyday
  // development.
  Crashlytics.instance.enableInDevMode = true;

  // Pass all uncaught errors from the framework to Crashlytics.
  FlutterError.onError = Crashlytics.instance.recordFlutterError;

  // Get an instance so that globals is initialised
  var prefs =  await SharedPreferences.getInstance();
  // Let's initialise the app state with the stored preferences
  var appState = new AppStateModel(prefs);
  // Build a route that can switch between homepage and login page
  var routes = <String, WidgetBuilder>{
    "/HomePage": (BuildContext context) => new ScopedModel<AppStateModel>(
        model: appState,
        child: new HomePage()
    ),
    "/LoginPage": (BuildContext context) => new ScopedModel<AppStateModel>(
        model: appState,
        child: new LoginPage()
    ),
  };

  // Use dart zone to define Crashlytics as error handler for errors 
  // that occur outside runApp
  runZoned<Future<Null>>(() async {
    runApp(new MaterialApp(
      onGenerateTitle: (context) => S.of(context).appTitle,
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      localeResolutionCallback: S.delegate.resolution(fallback: new Locale("en", "")),
      home: new ScopedModel<AppStateModel>(
          model: appState,
          child: new HomePage()
      ),
      theme: appTheme,
      routes: routes,
    ));
  }, onError: Crashlytics.instance.recordError);

}
