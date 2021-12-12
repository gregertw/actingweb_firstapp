import 'package:first_app/models/locstate.dart';

class MockMap {
  Geo? mockGeo;

  Geo? getGeo() {
    return mockGeo;
  }

  void enableGeo(Geo obj) {
    mockGeo = obj;
  }

  void disableMock(String mock) {
    if (mock == 'geo') {
      mockGeo = null;
    }
  }

  void clearMocks() {
    mockGeo = null;
  }
}
