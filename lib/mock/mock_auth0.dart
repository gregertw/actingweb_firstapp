import 'package:mockito/mockito.dart';
import 'package:flutter_auth0/flutter_auth0.dart';

class MockWebAuth extends Fake implements WebAuth {
  @override
  Future<Map<dynamic, dynamic>> authorize(dynamic) {
    return Future.value({'access_token': 'an_access_token'});
  }
}

// Create a class that fakes the auth0 library class
class MockAuth0 extends Fake implements Auth0 {

  WebAuth webAuth = MockWebAuth();

}
