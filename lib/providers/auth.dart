import 'dart:async';
import 'dart:convert';
import 'package:first_app/environment.dart';
import 'package:oauth2_client/google_oauth2_client.dart';
import 'package:oauth2_client/oauth2_client.dart';
import 'package:oauth2_client/github_oauth2_client.dart';
import 'package:oauth2_client/access_token_response.dart';
import 'package:http/http.dart' as http;

/// Use this as authProvider in [AuthClient] for mocked auth.
class MockOAuth2Client extends GitHubOAuth2Client {
  MockOAuth2Client(
      {required String redirectUri, required String customUriScheme})
      : super(redirectUri: redirectUri, customUriScheme: customUriScheme);

  Future<AccessTokenResponse> getMockedResponse() async {
    return AccessTokenResponse.fromMap({
      'access_token': 'an_access_token',
      'refresh_token': 'a_refresh_token',
      'token_type': 'bearer',
      'scope': '',
      'expires_in': 3600
    });
  }
}

class AuthUserInfo {
  String? email;
  String? username;
  String? name;
  String? firstname;
  String? lastname;
  String? avatarUrl;

  AuthUserInfo();

  /// Instantiate from a json based on provider id
  AuthUserInfo.from(provider, Map<String, dynamic> info) {
    switch (provider) {
      case 'github':
      case 'github_web':
        email = info['email'] ?? info['login'];
        name ??= info['name'];
        username ??= info['login'];
        avatarUrl ??= info['avatar_url'];
        break;
      case 'google':
      case 'google_web':
        email = info['email'] ?? info['login'];
        name ??= info['name'];
        username ??= info['login'];
        avatarUrl ??= info['picture'];
        break;
      default:
        throw 'Does not know how to parse AuthUserInfo from $provider';
    }
  }
}

/// Auth provider handling all interaction with the identity provider.
///
/// It can be used in three ways: preconfigured with a set of providers and all
/// parameters hardcoded in the class, provider configs set here and
/// [clientId], [redirectUrl], and/or [scopes] supplied,
/// or by supplying an [OAuth2Client] instance as [authProvider] (this
/// is used when mocking).
/// TODO: Implement OIDC support when oauth_client package gets support.
class AuthClient {
  // discoveryUrl, authzEndpoint, and tokenEndpoint are necessary for custom OpenID Connect services
  // String? discoveryUrl, authzEndpoint, tokenEndpoint;

  /// Needs to match an allowed redirect URL set up in the auth provider's
  /// app config. Will override preconfigured providers in the class.
  String? redirectUrl;

  /// The client id supplied by the auth provider. Will override preconfigured providers in the class.
  String? clientId;

  /// The client secret to be used in token exchange. Needs to be protected.
  String? clientSecret;

  /// The scopes that should be requested from the auth provider. Will override preconfigured providers in the class.
  List<String>? scopes;

  /// should be set to true if this app is running in a browser.
  final bool web;

  /// For Android and iOS, this must match the URI in the [_redirectUrls].
  /// Must be the same as the Android applicationId and iOS bundle scheme.
  /// If not supplied, [AuthClient]'s configured [_customUriScheme] will be used.
  String? customUriScheme;

  /// A fully configured [OAuth2Client] that will override both preconfigured providers and
  /// [redirectUrl], [clientId], and [scopes].
  OAuth2Client? authProvider;

  /// The provider to choose among the preconfigured. Overridden by [authProvider] if set.
  /// The clientId, redirctUrl, and scopes can either be configured below or supplied
  /// when instansiating the class.
  String? provider;
  // For Android and iOS, this must match the URI in the [_redirectUrls].
  // Must be the same as the Android applicationId and iOS bundle scheme.
  static const String _customUriScheme = 'io.actingweb.firstapp';
  static const Map<String, String> _redirectUrls = {
    'mock': 'localhost',
    'github': 'io.actingweb.firstapp://oauthredirect',
    'github_web': 'https://gregertw.github.io/actingweb_firstapp_web/',
    'google': 'io.actingweb.firstapp:/oauthredirect',
    // Edit the port number below to debug locally, also oauth.js needs to be edited
    //'google_web': 'http://localhost:56906/'
    'google_web': 'https://gregertw.github.io/actingweb_firstapp_web/'
  };
  static const Map<String, List<String>> _scopes = {
    'github': <String>[],
    'github_web': <String>[],
    'google': <String>['email', 'profile'],
    'google_web': <String>['email', 'profile']
  };
  static const Map<String, Map<String, String>> _userInfoUrls = {
    'github': {'host': 'api.github.com', 'path': '/user'},
    'github_web': {'host': 'api.github.com', 'path': '/user'},
    'google': {'host': 'www.googleapis.com', 'path': '/oauth2/v1/userinfo'},
    'google_web': {'host': 'www.googleapis.com', 'path': '/oauth2/v1/userinfo'}
  };

  // End default configs

  // convenience to hold refresh token
  String? _refreshToken;
  // convenience to hold access token
  String? _accessToken;
  // convenience to hold id token (OIDC)
  String? _idToken;
  DateTime _expiresToken = DateTime.now();

  /// Creates Authorization header
  Map<String, String> get authHeader =>
      {'Authorization': 'Bearer $accessToken'};

  /// Active acess token if authenticated.
  String get accessToken => _accessToken ?? '';

  /// Refresh token if available.
  String get refreshToken => _refreshToken ?? '';

  /// Id token if OIDC is used.
  String get idToken => _idToken ?? '';

  /// Do we have an access token? (note: it may be expired)
  bool get isValid => _accessToken != null;

  /// The expiry timestamp of the access token
  DateTime get expires => _expiresToken;

  /// Has the access token expired?
  bool get isExpired => _expiresToken.difference(DateTime.now()).inSeconds <= 0;

  /// Should a refresh be done?
  bool get shouldRefresh => _refreshToken != null && !isValid;

  AuthClient(
      {required this.clientId,
      this.clientSecret,
      this.web = false,
      this.authProvider,
      this.provider,
      this.redirectUrl,
      this.scopes,
      this.customUriScheme
      // For future OIDC support
      //this.discoveryUrl,
      //this.authzEndpoint,
      //this.tokenEndpoint
      }) {
    // customUriScheme is only relevant for Android and iOS.
    customUriScheme ??= _customUriScheme;
    if (authProvider == null && provider != null) {
      setPresetIdentityProvider(provider!);
    }
  }

  /// Configure/override the identity provider settings.
  void setPresetIdentityProvider(String provider) {
    if (web && !provider.contains('_web')) {
      provider = '${provider}_web';
    }
    if (!_redirectUrls.containsKey(provider)) {
      throw 'No provider set and authProvider not supplied.';
    }
    this.provider = provider;
    redirectUrl = _redirectUrls[provider] ?? '';
    scopes = _scopes[provider] ?? <String>[];
    switch (provider) {
      case 'mock':
        authProvider = MockOAuth2Client(redirectUri: '', customUriScheme: '');
        clientId = '';
        clientSecret = '';
        break;
      case 'github':
        authProvider = GitHubOAuth2Client(
            redirectUri: redirectUrl!, customUriScheme: customUriScheme!);
        clientId = Environment.clientIdGithubApp;
        clientSecret = Environment.secretGithubApp;
        break;
      case 'github_web':
        // Github web is not supported from Github
        authProvider = GitHubOAuth2Client(
            redirectUri: redirectUrl!, customUriScheme: customUriScheme!);
        clientId = '';
        clientSecret = '';
        break;
      case 'google':
        authProvider = GoogleOAuth2Client(
            redirectUri: redirectUrl!, customUriScheme: customUriScheme!);
        clientId = Environment.clientIdGoogleApp;
        // For authorization code/PKCE exchanges, set explicit to null to avoid
        // that a secret is attempted used in the token exchange.
        clientSecret = null;
        break;
      case 'google_web':
        authProvider = GoogleOAuth2Client(
            redirectUri: redirectUrl!, customUriScheme: customUriScheme!);
        clientId = Environment.clientIdGoogleWeb;
        // For authorization code/PKCE exchanges, set explicit to null to avoid
        // that a secret is attempted used in the token exchange.
        clientSecret = Environment.secretGoogleWeb;
        break;
      default:
        throw 'No provider set and authProvider not supplied.';
    }
  }

  Future<AuthUserInfo> getUserInfo() async {
    if (isValid) {
      try {
        final http.Response httpResponse = await http.get(
            Uri(
                scheme: 'https',
                host: _userInfoUrls[provider]!['host'],
                path: _userInfoUrls[provider]!['path']),
            headers: authHeader);
        var res = httpResponse.statusCode == 200 ? httpResponse.body : '';
        if (res.isNotEmpty) {
          return AuthUserInfo.from(provider, jsonDecode(res));
        }
      } catch (e) {
        return AuthUserInfo();
      }
    }
    return AuthUserInfo();
  }

  bool _parseAuthResult(AccessTokenResponse res) {
    if (!res.isValid()) {
      return false;
    }
    if (res.accessToken == null) {
      closeSessions();
      return false;
    }
    _accessToken = res.accessToken;
    // TODO: Set idtoken here.
    if (res.expirationDate != null) {
      _expiresToken = res.expirationDate!;
    } else {
      _expiresToken = DateTime.now().add(Duration(seconds: res.expiresIn ?? 0));
    }
    if (res.hasRefreshToken()) {
      _refreshToken = res.refreshToken;
    }
    return true;
  }

  /// Recreates a session from a json. This is not a constructor for the entire object.
  void fromJson(Map<String, dynamic> json) {
    _accessToken = json['accessToken'] == '' ? null : json['accessToken'];
    _refreshToken = json['refreshToken'] == '' ? null : json['refreshToken'];
    _idToken = json['idToken'] == '' ? null : json['idToken'];
    _expiresToken = DateTime.parse(json['expires']);
    provider = json['provider'];
  }

  /// Creates a json map of the session.
  Map<String, dynamic> toJson() => {
        'accessToken': _accessToken ?? '',
        'refreshToken': _refreshToken ?? '',
        'idToken': _idToken ?? '',
        'expires': _expiresToken.toIso8601String(),
        'provider': provider
      };

  /// Creates a string of the session for storing to SharedPreferences et al.
  ///
  /// NOTE!!! This string is security sensitive and must be persisted securely.
  @override
  String toString() {
    return json.encode(toJson());
  }

  /// Recreates the session from a string created by [toString].
  ///
  /// You should trigger [autorizeOrRefresh] afterwards at a point where
  /// user dialog for authentication can be shown (if needed).
  void fromString(String input) {
    if (input.isNotEmpty) fromJson(json.decode(input));
  }

  /// May present a UI dialog to the user.
  Future<bool> authorizeOrRefresh([String? provider]) async {
    if (authProvider is MockOAuth2Client) {
      return _parseAuthResult(
          await (authProvider as MockOAuth2Client).getMockedResponse());
    }
    if (provider != this.provider && provider != null) {
      setPresetIdentityProvider(provider);
    }
    if (_accessToken != null) {
      if (isExpired) {
        if (_refreshToken != null) {
          return _parseAuthResult(await authProvider!
              .refreshToken(_refreshToken!, clientId: clientId!));
        }
      }
    }
    closeSessions();
    try {
      return _parseAuthResult(await authProvider!.getTokenWithAuthCodeFlow(
          clientId: clientId!, scopes: scopes, clientSecret: clientSecret));
    } catch (e) {
      return false;
    }
  }

  /// Clears out session
  void closeSessions() {
    _expiresToken = DateTime.now();
    _accessToken = null;
    _idToken = null;
    _refreshToken = null;
    return;
  }
}
