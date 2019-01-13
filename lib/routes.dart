import 'package:flutter/material.dart';
import 'pages/login/index.dart';
import 'pages/home/index.dart';
import 'theme/style.dart';

class Routes {

  var routes = <String, WidgetBuilder>{
    "/HomePage": (BuildContext context) => new HomePage()
  };

  Routes() {
    runApp(new MaterialApp(
      title: "ActingWeb First App",
      home: new LoginScreen(),
      theme: appTheme,
      routes: routes,
    ));
  }
}
