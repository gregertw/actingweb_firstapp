import 'package:mockito/mockito.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:first_app/providers/geo.dart';

// Create a class that fakes the Geolocator library class
class MockGeolocator extends Fake implements Geo {
  @override
  Future<LocationPermission> checkPermission() async {
    return LocationPermission.always;
  }

  @override
  Future<List<Placemark>> fromCoordinates(double latitude, double longitude,
      {String? localeIdentifier}) async {
    final List<Placemark> l = [];
    l.add(Placemark(name: 'Lonesome town', country: 'Norway'));
    return l;
  }

  @override
  Stream<Position> getPositionStream(
      {LocationAccuracy desiredAccuracy = LocationAccuracy.best,
      int distanceFilter = 0,
      bool forceAndroidLocationManager = false,
      Duration? intervalDuration,
      Duration? timeLimit}) async* {
    for (var i = 1; i < 11; i++) {
      await Future.delayed(const Duration(milliseconds: 10));
      yield Position(
          latitude: 59.893777 + i / 100,
          longitude: 10.7150951,
          speed: 0.0,
          accuracy: 0.0,
          speedAccuracy: 0.0,
          altitudeAccuracy: 0.0,
          headingAccuracy: 0.0,
          altitude: 0.0,
          heading: 0.0,
          timestamp: DateTime.now());
    }
  }
}
