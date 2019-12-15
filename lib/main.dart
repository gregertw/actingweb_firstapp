import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_crashlytics/flutter_crashlytics.dart';
import 'dart:async';
// See https://github.com/long1eu/flutter_i18n/pull/33
// until this PR is merged, the country code must be specified in the ARB-files
import 'generated/i18n.dart';
import 'models/appstate.dart';
import 'ui/pages/home/index.dart';
import 'ui/pages/login/index.dart';
import 'ui/theme/style.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  // A breaking change in the platform messaging, as of Flutter 1.12.13+hotfix.5,
  // we need to explicitly initialise bindings to get access to the BinaryMessenger
  // https://groups.google.com/forum/#!msg/flutter-announce/sHAL2fBtJ1Y/mGjrKH3dEwAJ
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase Crashlytics
  bool isInDebugMode = true;

  FlutterError.onError = (FlutterErrorDetails details) {
    if (isInDebugMode) {
      // In development mode simply print to console.
      FlutterError.dumpErrorToConsole(details);
    } else {
      // In production mode report to the application zone to report to
      // Crashlytics.
      Zone.current.handleUncaughtError(details.exception, details.stack);
    }
  };

  await FlutterCrashlytics().initialize();

  // Get an instance so that globals is initialised
  var prefs =  await SharedPreferences.getInstance();
  var appState = new AppStateModel(prefs);
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

  runZoned<Future<Null>>(() async {
    runApp(new MaterialApp(
      onGenerateTitle: (context) => S.of(context).appTitle,
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      localeListResolutionCallback: S.delegate.listResolution(fallback: const Locale('en', '')),
      localeResolutionCallback: S.delegate.resolution(fallback: const Locale('en', '')),
      home: new ScopedModel<AppStateModel>(
          model: appState,
          child: new HomePage()
      ),
      theme: appTheme,
      routes: routes,
    ));
  }, onError: (error, stackTrace) async {
    // Whenever an error occurs, call the `reportCrash` function. This will send
    // Dart errors to our dev console or Crashlytics depending on the environment.
    await FlutterCrashlytics().reportCrash(error, stackTrace, forceCrash: false);
  });

}
