import 'dart:async';
import 'dart:convert';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:http/http.dart' as http;

class AuthClient {
  final String? clientId, redirectUrl, authzEndpoint, tokenEndpoint;
  final List<String> scopes;
  String? discoveryUrl;
  FlutterAppAuth? authClient;

  // Default configs for using the demo.identityserver.io ConnectId service
  // Either use the discoveryUrl or the authzEndpoint and tokenEndpoint (to skip discovery)
  static const String _clientId = 'interactive.public.short';
  static const String _redirectUrl = 'io.actingweb.firstapp:/oauthredirect';
  static const String _discoveryUrl =
      'https://demo.identityserver.io/.well-known/openid-configuration';
  static const List<String> _scopes = <String>[
    'openid',
    'profile',
    'email',
    'offline_access',
    'api'
  ];
  // End default configs

  AuthClient(
      {this.authClient,
      this.clientId = _clientId,
      this.redirectUrl = _redirectUrl,
      this.discoveryUrl,
      this.authzEndpoint,
      this.tokenEndpoint,
      this.scopes = _scopes}) {
    authClient ??= FlutterAppAuth();
    // If no server URLs are supplied, use the demo service
    if (discoveryUrl == null && authzEndpoint == null) {
      discoveryUrl = _discoveryUrl;
    }
  }

  Future<dynamic> getUserInfo(accessToken) async {
    if (accessToken == null) {
      return <String, dynamic>{};
    }
    String _userInfo;
    try {
      final http.Response httpResponse = await http.get(
          Uri(
              scheme: 'https',
              host: 'demo.identityserver.io',
              path: '/api/test'),
          headers: <String, String>{'Authorization': 'Bearer $accessToken'});
      _userInfo = httpResponse.statusCode == 200 ? httpResponse.body : '';
      if (_userInfo.isEmpty) {
        return <String, dynamic>{};
      }

      return json.decode(_userInfo);
    } catch (e) {
      throw ArgumentError("Unable to parse results from getUserInfo() ");
    }
  }

  Future<Map<dynamic, dynamic>?> refreshToken(refreshToken) async {
    if (refreshToken == null) {
      return null;
    }
    try {
      final TokenResponse? _result = await authClient!.token(TokenRequest(
          _clientId, _redirectUrl,
          refreshToken: refreshToken,
          discoveryUrl: _discoveryUrl,
          scopes: _scopes));
      if (_result != null && _result.refreshToken == null) {
        return Map.from({});
      }
      return Map.from({
        'access_token': _result!.accessToken,
        'expires': _result.accessTokenExpirationDateTime,
        'id_token': _result.idToken,
        'refresh_token': _result.refreshToken,
        'additional_params': _result.tokenAdditionalParameters,
      });
    } catch (e) {
      return Map.from({});
    }
  }

  Future<Map<dynamic, dynamic>> authorize() async {
    AuthorizationTokenResponse? _result;
    try {
      if (discoveryUrl == null) {
        _result = await authClient!.authorizeAndExchangeCode(
          AuthorizationTokenRequest(
            clientId!,
            redirectUrl!,
            serviceConfiguration: AuthorizationServiceConfiguration(
                authzEndpoint!, tokenEndpoint!),
            scopes: scopes,
          ),
        );
      } else {
        _result = await authClient!.authorizeAndExchangeCode(
          AuthorizationTokenRequest(
            clientId!,
            redirectUrl!,
            discoveryUrl: discoveryUrl,
            scopes: scopes,
          ),
        );
      }
      if (_result != null && _result.accessToken != null) {
        return Map.from({
          'access_token': _result.accessToken,
          'expires': _result.accessTokenExpirationDateTime,
          'id_token': _result.idToken,
          'refresh_token': _result.refreshToken,
          'additional_params': _result.authorizationAdditionalParameters,
        });
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error: $e');
    }
    return Map.from({});
  }
}
