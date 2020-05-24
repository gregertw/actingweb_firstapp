import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:first_app/models/appstate.dart';
import 'package:first_app/models/locstate.dart';
import 'package:first_app/ui/pages/login/index.dart';
import 'package:first_app/generated/l10n.dart';
import 'package:first_app/ui/pages/location/index.dart';
import 'package:first_app/ui/pages/map/index.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<dynamic> firstappBackgroundMessageHandler(Map<String, dynamic> message) {
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
    print("Data in message: $data");
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
    print("Notification in message: $notification");
  }
  return Future<void>.value();
}

class HomePage extends StatelessWidget {

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  void initMessaging() {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
      },
      onBackgroundMessage: firstappBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );

    _firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(
            sound: true, badge: true, alert: true, provisional: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      print("Firebase messaging token: $token");
    });
  }

  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<AppStateModel>(context);
    if (!appState.authenticated) {
      return Scaffold(
        body: LoginPage(),
      );
    }
    initMessaging();
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).appTitle),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: new ChangeNotifierProvider(
        create: (_) => new LocStateModel(appState.mocks.getMock('geolocator')),
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
