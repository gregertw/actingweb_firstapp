import 'package:flutter/material.dart';
import 'package:first_app/models/appstate.dart';
import 'package:first_app/ui/pages/login/index.dart';
import 'package:first_app/generated/i18n.dart';
import '../location/index.dart';
import '../map/index.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    var appState = AppStateModel.of(context, true);
    if (!appState.authenticated){
      return Scaffold(
        body: LoginPage(),
      );
    }
    return Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).appTitle),
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              LocationStreamWidget(),
              OverlayMapPage(),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: AppStateModel.of(context, false).logOut,
          tooltip: S.of(context).logoutButton,
          child: Icon(
            Icons.exit_to_app,
            color: Color(0xe81751ff),
          ),
          backgroundColor: Theme.of(context).buttonColor,
          foregroundColor: Theme.of(context).focusColor,
        ));
  }
}
