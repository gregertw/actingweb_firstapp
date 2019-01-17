import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
        child: new HomePage(title: "ActingWeb App")
    ),
    "/LoginPage": (BuildContext context) => new ScopedModel<AppStateModel>(
      model: appState,
      child: new LoginPage()
    ),
  };

  runApp(new MaterialApp(
    title: "ActingWeb First App",
    home: new ScopedModel<AppStateModel>(
        model: appState,
        child: new HomePage(title: "ActingWeb App")
    ),
    theme: appTheme,
    routes: routes,
  ));
}
