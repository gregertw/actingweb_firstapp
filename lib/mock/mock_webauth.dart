import 'package:mockito/mockito.dart';
import 'package:flutter_auth0/flutter_auth0.dart';

// Create a class that fakes the auth0 library class
class MockWebAuth extends Fake implements WebAuth {
  @override
  Future authorize(
      {String state, String nonce, audience, scope, String connection}) {
    return Future.value({'access_token': 'an_access_token'});
  }
}
