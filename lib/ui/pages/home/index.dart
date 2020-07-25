import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:first_app/models/appstate.dart';
import 'package:first_app/models/locstate.dart';
import 'package:first_app/ui/pages/login/index.dart';
import 'package:first_app/generated/l10n.dart';
import 'package:first_app/ui/pages/location/index.dart';
import 'package:first_app/ui/pages/map/index.dart';
import 'drawer.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<AppStateModel>(context);
    if (!appState.authenticated) {
      return Scaffold(
        body: LoginPage(),
      );
    }

    // as documented in appstate.dart, we here set the defaultLokale
    // from appState to apply loaded locale from sharedpreferences on
    // startup.
    Intl.defaultLocale = appState.locale;

    return Scaffold(
        key: Key("HomePage_Scaffold"),
        appBar: AppBar(
          title: Text(S.of(context).appTitle),
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        body: new ChangeNotifierProvider(
          create: (_) =>
              new LocStateModel(appState.mocks.getMock('geolocator')),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                LocationStreamWidget(),
                OverlayMapPage(),
              ],
            ),
          ),
        ),
        drawer: HomePageDrawer());
  }
}
