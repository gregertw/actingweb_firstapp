import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:first_app/providers/auth.dart';

class AppStateModel extends Model {
  bool _authenticated = false;
  String _userToken;
  String _idToken;
  String _refreshToken;
  DateTime _expires;
  String _email;
  final SharedPreferences prefs;

  bool get authenticated => _authenticated;
  String get userToken => _userToken;
  String get idToken => _idToken;
  String get refreshToken => _refreshToken;
  DateTime get expires => _expires;
  String get email => _email;

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
        var auth = await Auth0Client().refreshToken(prefs.getString('refreshToken'));
        if (auth != null && auth.containsKey('access_token') ) {
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
    if (data.containsKey('email')){
      prefs.setString('email', data['email']);
      _email = data['email'];
    }
    notifyListeners();
  }

  void logIn(data) {
    if(data.containsKey('access_token')) {
      prefs.setString('userToken', data['access_token']);
      _userToken = data['access_token'];
      _authenticated = true;
    }
    if(data.containsKey('refresh_token')) {
      prefs.setString('refreshToken', data['refresh_token']);
      _refreshToken = data['refresh_token'];
    }
    if(data.containsKey('id_token')) {
      prefs.setString('idToken', data['id_token']);
      _idToken = data['id_token'];
    }
    if(data.containsKey('expires_in')) {
      var _expires = new DateTime.now().add(
          new Duration(seconds: data['expires_in']));
      prefs.setString('expires', _expires.toIso8601String());
    }
    notifyListeners();
  }

  void logOut() {
    Auth0Client().closeSessions();
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