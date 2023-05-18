// ignore_for_file: unnecessary_new

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:first_app/models/appstate.dart';
import 'package:first_app/models/locstate.dart';
import 'package:first_app/ui/pages/login/index.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:first_app/ui/pages/location/index.dart';
import 'package:first_app/ui/pages/map/index.dart';
import 'drawer.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<AppStateModel>(context);
    if (!appState.authenticated) {
      return const Scaffold(
        body: LoginPage(),
      );
    }

    return Scaffold(
        key: const Key("HomePage_Scaffold"),
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.appTitle),
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
        body: ChangeNotifierProvider(
          create: (_) => new LocStateModel(appState.mocks.getGeo()),
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                LocationStreamWidget(),
                OverlayMapPage(),
              ],
            ),
          ),
        ),
        drawer: const HomePageDrawer());
  }
}
