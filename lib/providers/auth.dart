import 'dart:async';
import 'package:flutter_auth0/flutter_auth0.dart';

class AuthClient {
  final String clientId, domain;
  Auth0 authClient;

  AuthClient(
      {this.authClient,
      this.clientId: 'PJVgy3Vh9jo7Wxl6sSUZsicE6S4TXZjB',
      this.domain: 'actingweb.eu.auth0.com'}) {
    if (authClient == null) {
      authClient = Auth0(baseUrl: 'https://$domain/', clientId: clientId);
    }
  }

  Future<dynamic> getUserInfo(accessToken) async {
    if (accessToken == null) {
      return null;
    }
    var client = Auth0Auth(
        authClient.auth.clientId, authClient.auth.client.baseUrl,
        bearer: 'user access_token');
    return Map.from(await client.getUserInfo());
  }

  Future<Map<dynamic, dynamic>> refreshToken(refreshToken) async {
    if (refreshToken == null) {
      return null;
    }
    return Map.from(await authClient.webAuth.client.refreshToken({
      'refreshToken': 'user refresh_token',
    }));
  }

  void closeSessions() {
    authClient.webAuth.clearSession();
  }

  Future<Map<dynamic, dynamic>> authorize() async {
    try {
      var _result = await authClient.webAuth.authorize({
        'audience': 'https://$domain/userinfo',
        'scope': 'openid email offline_access',
      });
      var res = Map.from(_result);
      if (res.containsKey('access_token')) {
        return res;
      }
    } catch (e) {
      print('Error: $e');
    }
    return null;
  }
}
