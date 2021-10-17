import 'package:mockito/mockito.dart';
import 'package:flutter_appauth/flutter_appauth.dart';

class MockAuthorizationTokenResponse extends Fake
    implements AuthorizationTokenResponse {
  @override
  final accessToken = 'an_access_token';
  @override
  final accessTokenExpirationDateTime = DateTime.now();
  @override
  final idToken = 'id_token';
  @override
  final refreshToken = 'a_refresh_token';
  @override
  final authorizationAdditionalParameters = Map.from({
    'param': 1,
  });
  @override
  final tokenAdditionalParameters = Map.from({
    'param': 1,
  });
}

// Mock the appauth library
class MockFlutterAppAuth extends Fake implements FlutterAppAuth {
  @override
  Future<AuthorizationTokenResponse> authorizeAndExchangeCode(dynamic) {
    return Future.value(MockAuthorizationTokenResponse());
  }

  @override
  Future<AuthorizationTokenResponse> token(dynamic) {
    return Future.value(MockAuthorizationTokenResponse());
  }
}
