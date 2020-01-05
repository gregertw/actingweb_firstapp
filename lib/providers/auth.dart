import 'dart:async';
import 'package:flutter_auth0/flutter_auth0.dart';

class Auth0Client {
  final String clientId, domain;
  WebAuth authClient;

  Auth0Client(
      {this.authClient,
      this.clientId: 'PJVgy3Vh9jo7Wxl6sSUZsicE6S4TXZjB',
      this.domain: 'actingweb.eu.auth0.com'}) {
    if (authClient == null) {
      authClient = new WebAuth(clientId: clientId, domain: domain);
    }
  }

  Future<String> firebaseDelegationToken(idToken) async {
    if (idToken == null) {
      return null;
    }
    String token = await authClient.delegate(token: idToken, api: 'firebase');
    return token;
  }

  Future<dynamic> getUserInfo(accessToken) async {
    if (accessToken == null) {
      return null;
    }
    return Map.from(await authClient.userInfo(token: accessToken));
  }

  Future<Map<dynamic, dynamic>> refreshToken(refreshToken) async {
    if (refreshToken == null) {
      return null;
    }
    return Map.from(await authClient.refreshToken(refreshToken: refreshToken));
  }

  void closeSessions() {
    authClient.clearSession();
  }

  Future<Map<dynamic, dynamic>> authorize() async {
    var _result = await authClient.authorize(
      audience: 'https://$domain/userinfo',
      scope: 'openid email offline_access',
    );
    var res = Map.from(_result);
    if (res.containsKey('access_token')) {
      return res;
    }
    return null;
  }
}
