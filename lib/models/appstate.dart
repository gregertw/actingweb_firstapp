import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:first_app/providers/auth.dart';
import 'package:first_app/mock/mockmap.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:first_app/environment.dart';
// Import mock packages for the web version
import 'package:first_app/mock/mock_geolocator.dart';

/// Kicks in when we receive a firebase message in the background.
///
/// Could be used to trigger actions.
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // ignore: avoid_print
  print("Handling a background message: ${message.messageId}");
}

/// Main state class for top-level login state
class AppStateModel with ChangeNotifier {
  bool _authenticated = false;
  AuthUserInfo _userInfo = AuthUserInfo();
  String? _locale;
  late Locale _currentLocale;
  String? _fcmToken;
  bool mock;
  bool web;
  SharedPreferences? prefs;
  FirebaseAnalytics? analytics;
  FirebaseMessaging? messaging;
  AuthClient? _authClient;
  // We use a mockmap to enable and disable mock functions/classes.
  // The mock should be injected as a dependency where external dependencies need
  // to be mocked as part of testing.
  final MockMap _mocks = MockMap();

  bool get authenticated => _authenticated;
  bool get isWeb => web;
  String? get userToken => _authClient!.accessToken;
  String? get idToken => _authClient!.idToken;
  String? get refreshToken => _authClient!.refreshToken;
  DateTime? get expires => _authClient!.expires;
  String get email => _userInfo.email ?? '';
  String get name => _userInfo.name ?? '';
  MockMap get mocks => _mocks;
  String? get localeAbbrev => _locale;
  Locale get locale => _currentLocale;
  String? get fcmToken => _fcmToken;
  AuthClient? get auth => _authClient;

  AppStateModel(
      {this.prefs,
      this.analytics,
      this.messaging,
      this.mock = false,
      this.web = false}) {
    if (mock) {
      mocks.enableGeo(MockGeolocator());
      _authClient = AuthClient(
          provider: 'mock', clientId: '', clientSecret: '', web: web);
    } else {
      _authClient = AuthClient(
          clientId: Environment.clientIdGithubApp,
          clientSecret: Environment.secretGithubApp,
          web: web);
    }
    refreshSession();
    // this will load locale from prefs
    // Note that you need to use
    // Intl.defaultLocale = appState.localeAbbrev;
    // in your main page(s) builders to apply a loaded locale from prefs
    // as the widget tree will not automatically refresh until build time
    // See lib/ui/pages/home/index.dart for an example.
    setLocale(null);
    // Initialise Firebase messaging
    _initMessaging();
  }

  void _initMessaging() async {
    if (messaging == null) {
      return;
    }
    // On Web platform the iOS specific code is not ignored transparently
    // as for Android
    if (web) {
      // Firebase messaging does not support Flutter natively yet, so under
      // web, the token is retrieved in a script in web/index.html
      _fcmToken = 'only_available_in_js';
      return;
    }
    NotificationSettings settings = await messaging!.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    // ignore: avoid_print
    print('User granted permission: ${settings.authorizationStatus}');

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // ignore: avoid_print
      print("onMessage: $message");
      if (message.notification != null) {
        // ignore: avoid_print
        print('Message also contained a notification: ${message.notification}');
      }
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    messaging!.getToken().then((String? token) {
      assert(token != null);
      // ignore: avoid_print
      print("Firebase messaging token: $token");
      _fcmToken = token;
    });
    messaging!.onTokenRefresh.listen((newToken) {
      _fcmToken = newToken;
    });
  }

  /// Use to set locale explicitly.
  void setLocale(String? loc) {
    if (prefs == null) {
      return;
    }
    if (loc == null) {
      loc = prefs!.getString('locale');
      loc ??= Intl.getCurrentLocale().substring(0, 2);
    }
    _locale = loc;
    prefs!.setString('locale', loc);
    _currentLocale = Locale(loc);
    notifyListeners();
  }

  /// Rotates through the supported locales.
  void switchLocale() {
    const _locales = AppLocalizations.supportedLocales;
    if (_locales.length == 1) {
      return;
    }
    int ind = 0;
    _locales.asMap().forEach((key, value) {
      if (value.languageCode == _locale) {
        ind = key + 1;
      }
    });
    if (ind >= _locales.length) {
      ind = 0;
    }
    setLocale(_locales[ind].languageCode);
  }

  /// Sends off a Firebase Analytics event.
  Future<void> sendAnalyticsEvent(
      String name, Map<String, dynamic>? params) async {
    if (analytics == null) {
      return;
    }
    await analytics!.logEvent(
      name: name,
      parameters: params,
    );
    // ignore: avoid_print
    print('Sent analytics events: $name');
  }

  /// Refreshes a session from sharedpreferences.
  Future<bool> refreshSession() async {
    if (prefs == null || _authClient == null) {
      return false;
    }
    _userInfo.email = prefs!.getString('email');
    _userInfo.name = prefs!.getString('name');
    _authClient!.fromString(prefs!.getString('session') ?? '');
    if (_authClient!.isValid && !_authClient!.isExpired) {
      _authenticated = true;
      notifyListeners();
      return true;
    }
    logOut();
    return false;
  }

  /// Trigger retrieving more user info from the identity provider.
  void setUserInfo() async {
    _userInfo = await _authClient!.getUserInfo();
    prefs!.setString('email', email);
    prefs!.setString('name', name);
    notifyListeners();
  }

  /// Triggers  a popup for login to the Identity Provider
  Future<bool> authorize([String? provider]) async {
    var res = await _authClient?.authorizeOrRefresh(provider);
    if (res ?? false) {
      prefs!.setString('session', _authClient.toString());
      _authenticated = true;
      notifyListeners();
      return true;
    }
    notifyListeners();
    return false;
  }

  // Clears out and deletes the token as well as in sharedpreferences.
  void logOut() {
    _authClient?.closeSessions();
    _authenticated = false;
    prefs!.remove('session');
    notifyListeners();
  }
}
