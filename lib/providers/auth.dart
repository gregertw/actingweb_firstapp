import 'dart:async';
import 'package:flutter_auth0/flutter_auth0.dart';
import 'package:first_app/globals.dart';

final String clientId = 'PJVgy3Vh9jo7Wxl6sSUZsicE6S4TXZjB';
final String domain = 'actingweb.eu.auth0.com';


class Auth0 {
  var _result;
  final WebAuth web = new WebAuth(clientId: clientId, domain: domain);

  Future<String> _delegationToken() async {
    if (_result == null) {
      return null;
    }
    String token = await web.delegate(token: _result['id_token'], api: 'firebase');
    return '''[Delegation Token Success] 
    Access Token: $token''';
  }

  Future<String> _userInfo() async {
    if (_result == null) {
      return null;
    }
    dynamic response = await web.userInfo(token: _result['access_token']);
    StringBuffer buffer = new StringBuffer();
    response.forEach((k, v) => buffer.writeln('$k: $v'));
    return '''[User Info] 
    ${buffer.toString()}''';
  }

  void _refreshToken() {
    web
        .refreshToken(refreshToken: _result['refresh_token'])
        .then((value) => print('response: $value'))
        .catchError((err) => print('Error: $err'));
  }

  void _closeSessions() {
    web.clearSession().catchError((err) => print(err));
  }

  Future<bool> authorize() async {
    var _result = await web.authorize(
      audience: 'https://actingweb.eu.auth0.com/userinfo',
      scope: 'openid email offline_access',
    );
    var res = Map.from(_result);
    if (res.containsKey('access_token')) {
      globalPrefs.setString('userToken', _result['access_token']);
      globalPrefs.setString('refreshToken', _result['refresh_token']);
      globalPrefs.setString('idToken', _result['id_token']);
      var expires = new DateTime.now().add(
          new Duration(seconds: _result['expires_in']));
      globalPrefs.setString('expires', expires.toIso8601String());
      return true;
    }
    return false;
  }

}