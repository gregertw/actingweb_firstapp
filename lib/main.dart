import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'globals.dart';
import 'ui/pages/wait/index.dart';
import 'ui/pages/home/index.dart';
import 'ui/theme/style.dart';

void main() async {

  // Get an instance so that globals is initialised
  globalPrefs = await SharedPreferences.getInstance();
  var userToken = globalPrefs.getString('userToken');
  var expiresStr = globalPrefs.getString('expires');
  if (expiresStr != null){
    var expires = DateTime.parse(expiresStr);
    var remaining = expires.difference(DateTime.now());
    if (remaining.inSeconds < 3600) {
      userToken = null;
    }
  }
  var routes = <String, WidgetBuilder>{
    "/HomePage": (BuildContext context) => new HomePage()
  };

  runApp(new MaterialApp(
    title: "ActingWeb First App",
    home: new WaitPage(),
    theme: appTheme,
    routes: routes,
  ));
}
