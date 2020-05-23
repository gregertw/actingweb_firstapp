import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:first_app/providers/auth.dart';
import 'package:first_app/mock/mockmap.dart';

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

class AppStateModel with ChangeNotifier {
  bool _authenticated = false;
  String _userToken;
  String _idToken;
  String _refreshToken;
  DateTime _expires;
  String _email;
  final SharedPreferences prefs;
  // We use a mockmap to enable and disable mock functions/classes.
  // The mock should be injected as a dependency where external dependencies need
  // to be mocked as part of testing.
  MockMap _mocks = MockMap();

  bool get authenticated => _authenticated;
  String get userToken => _userToken;
  String get idToken => _idToken;
  String get refreshToken => _refreshToken;
  DateTime get expires => _expires;
  String get email => _email;
  MockMap get mocks => _mocks;

  AppStateModel(this.prefs) {
    refresh();
  }

  void refresh() async {
    // Check if the stored token has expired
    var expiresStr = prefs.getString('expires');
    if (expiresStr != null) {
      _expires = DateTime.parse(expiresStr);
      var remaining = _expires.difference(DateTime.now());
      if (remaining.inSeconds < 3600) {
        var auth = await AuthClient(authClient: _mocks.getMock('authClient'))
            .refreshToken(prefs.getString('refreshToken'));
        if (auth != null && auth.containsKey('access_token')) {
          logIn(auth);
        } else {
          prefs.remove('userToken');
          prefs.remove('expires');
          _authenticated = false;
          _userToken = null;
          _expires = null;
        }
        notifyListeners();
        return;
      }
    }
    _userToken = prefs.getString('userToken');
    if (_userToken != null) {
      _authenticated = true;
    }
    _idToken = prefs.getString('idToken');
    _refreshToken = prefs.getString('refreshToken');
    notifyListeners();
  }

  void setUserInfo(data) {
    if (data == null) {
      return;
    }
    if (data.containsKey('email')) {
      prefs.setString('email', data['email']);
      _email = data['email'];
    }
    notifyListeners();
  }

  void logIn(data) {
    if (data == null) {
      return;
    }
    if (data.containsKey('access_token')) {
      prefs.setString('userToken', data['access_token']);
      _userToken = data['access_token'];
      _authenticated = true;
    }
    if (data.containsKey('refresh_token')) {
      prefs.setString('refreshToken', data['refresh_token']);
      _refreshToken = data['refresh_token'];
    }
    if (data.containsKey('id_token')) {
      prefs.setString('idToken', data['id_token']);
      _idToken = data['id_token'];
    }
    if (data.containsKey('expires')) {
      var _expires = data['expires'];
      prefs.setString('expires', _expires.toIso8601String());
    }
    notifyListeners();
  }

  void logOut() {
    /* When logging out, the app session is cleared and a new login is needed.
    However, if Auth0 is configured with an IdP, like Google, and the account
    is logged into Google on the device, the user will be directly logged in.
    If closeSessions() is called, the Auth0 session and the IdP session will be 
    logged out. However, the user will be redirected to the IdP login page, which
    may be confusing.
    */
    //AuthClient(authClient:_mocks.getMock('authClient')).closeSessions();
    _authenticated = false;
    _userToken = null;
    _idToken = null;
    _refreshToken = null;
    _expires = null;
    prefs.clear();
    notifyListeners();
  }
}
