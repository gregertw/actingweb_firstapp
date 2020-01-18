import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:first_app/models/appstate.dart';
import 'package:first_app/models/locstate.dart';
import 'package:first_app/ui/pages/login/index.dart';
import 'package:first_app/generated/i18n.dart';
import 'package:first_app/ui/pages/location/index.dart';
import 'package:first_app/ui/pages/map/index.dart';

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<AppStateModel>(context);
    if (!appState.authenticated) {
      return Scaffold(
        body: LoginPage(),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).appTitle),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: new ChangeNotifierProvider(
        create: (_) => new LocStateModel(),
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
      floatingActionButton: FloatingActionButton(
        onPressed: appState.logOut,
        tooltip: S.of(context).logoutButton,
        key: Key('HomePage_ExitButton'),
        child: Icon(
          Icons.exit_to_app,
          color: Color(0xe81751ff),
        ),
        backgroundColor: Theme.of(context).buttonColor,
        foregroundColor: Theme.of(context).focusColor,
      ),
    );
  }
}
