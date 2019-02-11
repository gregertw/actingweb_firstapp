import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'generated/i18n.dart';
import 'globals.dart';
import 'models/appstate.dart';
import 'ui/pages/home/index.dart';
import 'ui/pages/login/index.dart';
import 'ui/theme/style.dart';

void main() async {
  // Get an instance so that globals is initialised
  globalPrefs = await SharedPreferences.getInstance();
  var appState = new AppStateModel(globalPrefs);
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
}
