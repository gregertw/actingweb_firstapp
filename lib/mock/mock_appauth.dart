import 'package:mockito/mockito.dart';
import 'package:flutter_appauth/flutter_appauth.dart';

class MockAuthorizationTokenResponse extends Fake
    implements AuthorizationTokenResponse {
  final accessToken = 'an_access_token';
  final accessTokenExpirationDateTime = new DateTime.now();
  final idToken = 'id_token';
  final refreshToken = 'a_refresh_token';
  final authorizationAdditionalParameters = Map.from({
    'param': 1,
  });
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
