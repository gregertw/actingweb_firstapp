import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:first_app/providers/auth.dart';
import 'package:first_app/mock/mockmap.dart';

class AppStateModel extends Model {
  bool _authenticated = false;
  String _userToken;
  String _idToken;
  String _refreshToken;
  DateTime _expires;
  String _email;
  final SharedPreferences prefs;
  double _latitude = 0.0;
  double _longitude = 0.0;
  // We use a mockmap to enable and disable mock functions/classes.
  // The mock should be injected as a dependency where external dependencies need
  // to be mocked as part of testing.
  MockMap _mocks = MockMap();

  double get latitude => _latitude;
  double get longitude => _longitude;
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
        var auth =
            await Auth0Client(authClient:_mocks.getMock('authClient')).refreshToken(prefs.getString('refreshToken'));
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

  void setLocation(double lat, double lon) {
    _latitude = lat;
    _longitude = lon;
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
    if (data.containsKey('expires_in')) {
      var _expires =
          new DateTime.now().add(new Duration(seconds: data['expires_in']));
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
    // Auth0Client().closeSessions();
    _authenticated = false;
    _userToken = null;
    _idToken = null;
    _refreshToken = null;
    _expires = null;
    prefs.clear();
    notifyListeners();
  }

  static AppStateModel of(BuildContext context, rebuild) =>
      ScopedModel.of<AppStateModel>(context, rebuildOnChange: rebuild);
}
