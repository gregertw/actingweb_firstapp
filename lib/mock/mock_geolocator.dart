import 'package:mockito/mockito.dart';
import 'package:geolocator/geolocator.dart';

// Create a class that fakes the Geolocator library class
class MockGeolocator extends Fake implements Geolocator {
  @override
  Future<GeolocationStatus> checkGeolocationPermissionStatus(
      {GeolocationPermission locationPermission =
          GeolocationPermission.location}) async {
    return GeolocationStatus.granted;
  }

  @override
  Future<List<Placemark>> placemarkFromCoordinates(
      double latitude, double longitude,
      {String localeIdentifier}) async {
    final List<Placemark> l = List<Placemark>();
    l.add(Placemark(name: 'Lonesome town', country: 'Norway'));
    return l;
  }

  @override
  Stream<Position> getPositionStream(
      [LocationOptions locationOptions = const LocationOptions(),
      GeolocationPermission locationPermissionLevel =
          GeolocationPermission.location]) async* {
    for (var i=1; i < 11; i++) {
      await Future.delayed(Duration(milliseconds: 10));
      yield Position(latitude: 59.893777+i/100, longitude: 10.7150951);
    }
  }
}
