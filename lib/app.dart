import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:first_app/models/appstate.dart';
import 'package:first_app/ui/pages/home/index.dart';
import 'package:first_app/ui/pages/login/index.dart';
import 'package:first_app/ui/theme/style.dart';

class ProviderApp extends StatelessWidget {
  final SharedPreferences prefs;
  final FirebaseAnalytics analytics;
  final FirebaseMessaging firebaseMessaging;
  final bool mock;

  ProviderApp({
    required this.prefs,
    required this.analytics,
    required this.firebaseMessaging,
    required this.mock,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppStateModel(
          this.prefs, this.analytics, this.firebaseMessaging, this.mock),
      child: MaterialApp(
        debugShowCheckedModeBanner:
            false, // set to true to see the debug banner
        // Providing a restorationScopeId allows the Navigator built by the
        // MaterialApp to restore the navigation stack when a user leaves and
        // returns to the app after it has been killed while running in the
        // background.
        restorationScopeId: 'first_app',
        navigatorObservers: [
          FirebaseAnalyticsObserver(analytics: analytics),
        ],
        onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: HomePage(),
        theme: appTheme,
        routes: <String, WidgetBuilder>{
          "/HomePage": (BuildContext context) => HomePage(),
          "/LoginPage": (BuildContext context) => LoginPage(),
        },
      ),
    );
  }
}

Future<Widget> getApp({bool mock: false}) async {
  FirebaseAnalytics analytics = FirebaseAnalytics();

  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  // Get an instance so that globals are initialised
  var prefs = await SharedPreferences.getInstance();

  return ProviderApp(
      prefs: prefs,
      analytics: analytics,
      firebaseMessaging: firebaseMessaging,
      mock: mock);
}
