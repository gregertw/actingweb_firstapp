import 'package:oauth2_client/oauth2_client.dart';
import 'package:first_app/models/locstate.dart';

class MockMap {
  Geo? mockGeo;
  OAuth2Client? mockAppAuth;

  Geo? getGeo() {
    return mockGeo;
  }

  OAuth2Client? getAppAuth() {
    return mockAppAuth;
  }

  void enableGeo(Geo obj) {
    mockGeo = obj;
  }

  void enableAppAuth(OAuth2Client obj) {
    mockAppAuth = obj;
  }

  void disableMock(String mock) {
    if (mock == 'geo') {
      mockGeo = null;
    }
    if (mock == 'appauth') {
      mockAppAuth = null;
    }
  }

  void clearMocks() {
    mockGeo = null;
    mockAppAuth = null;
  }
}
