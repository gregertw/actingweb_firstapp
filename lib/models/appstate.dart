import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppStateModel extends Model {
  bool _authenticated = false;
  String _userToken;
  String _idToken;
  String _refreshToken;
  DateTime _expires;
  SharedPreferences _prefs;

  bool get authenticated => _authenticated;
  String get userToken => _userToken;
  String get idToken => _idToken;
  String get refreshToken => _refreshToken;
  DateTime get expires => _expires;

  AppStateModel(prefs) {
    _prefs = prefs;
    refresh();
  }

  void refresh() {
    // Check if the stored token has expired
    var expiresStr = _prefs.getString('expires');
    if (expiresStr != null) {
      _expires = DateTime.parse(expiresStr);
      var remaining = _expires.difference(DateTime.now());
      if (remaining.inSeconds < 3600) {
        _prefs.remove('userToken');
        _prefs.remove('expires');
        _authenticated = false;
        _userToken = null;
        _expires = null;
      }
    }
    _userToken = _prefs.getString('userToken');
    if (_userToken != null) {
      _authenticated = true;
    }
    _idToken = _prefs.getString('idToken');
    _refreshToken = _prefs.getString('refreshToken');
    notifyListeners();
  }

  void logOut() {
    _authenticated = false;
    _userToken = null;
    _idToken = null;
    _refreshToken = null;
    _expires = null;
    _prefs.clear();
    notifyListeners();
  }

  static AppStateModel of(BuildContext context, rebuild) =>
      ScopedModel.of<AppStateModel>(context, rebuildOnChange: rebuild);
}