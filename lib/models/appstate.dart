import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:first_app/providers/auth.dart';
import 'package:first_app/mock/mockmap.dart';
import 'package:first_app/generated/l10n.dart';

class AppStateModel with ChangeNotifier {
  bool _authenticated = false;
  String _userToken;
  String _idToken;
  String _refreshToken;
  DateTime _expires;
  String _email;
  String _name;
  String _locale;
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
  String get name => _name;
  MockMap get mocks => _mocks;
  String get locale => _locale;

  AppStateModel(this.prefs) {
    refresh();
    // this will load locale from prefs
    // Note that you need to use
    // Intl.defaultLocale = appState.locale;
    // in your main page(s) builders to apply a loaded locale from prefs
    // as the widget tree will not automatically refresh until build time
    // See lib/ui/pages/home/index.dart for an example.
    setLocale(null);
  }

  void setLocale(String loc) {
    if (loc == null) {
      loc = prefs.getString('locale');
      if (loc == null) {
        loc = Intl.getCurrentLocale().substring(0, 2);
      }
    }
    _locale = loc;
    S.load(Locale(_locale));
    prefs.setString('locale', _locale);
    notifyListeners();
  }

  void switchLocale() {
    final _locales = S.delegate.supportedLocales;
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
    if (data.containsKey('name')) {
      prefs.setString('name', data['name']);
      _name = data['name'];
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
      _expires = data['expires'];
      prefs.setString('expires', _expires.toIso8601String());
    }
    notifyListeners();
  }

  void logOut() {
    /* Here you can also close the sessions with the AuthClient
       (if supported). closeSessions() is not implemented here as it
       involves clearing cookies in the webview (for demo.identityprovider.io).
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
