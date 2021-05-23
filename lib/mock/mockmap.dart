import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:first_app/models/locstate.dart';

class MockMap {
  Geo? mockGeo;
  FlutterAppAuth? mockAppAuth;

  Geo? getGeo() {
    return mockGeo;
  }

  FlutterAppAuth? getAppAuth() {
    return mockAppAuth;
  }

  void enableGeo(Geo obj) {
    mockGeo = obj;
  }

  void enableAppAuth(FlutterAppAuth obj) {
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
