import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class Geo {
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;

  Future<LocationPermission?> checkPermission() async {
    var enabled = await _geolocatorPlatform.isLocationServiceEnabled();
    if (enabled) {
      var permission = await _geolocatorPlatform.checkPermission();
      if (permission == LocationPermission.denied) {
        return await Geolocator.requestPermission();
      }
      return permission;
    }
    return null;
  }

  Future<List<Placemark>> fromCoordinates(double latitude, double longitude,
      {String? localeIdentifier}) {
    return placemarkFromCoordinates(latitude, longitude);
  }

  Stream<Position> getPositionStream(
      {LocationAccuracy desiredAccuracy = LocationAccuracy.best,
      int distanceFilter = 0,
      Duration? timeLimit}) {
    return Geolocator.getPositionStream(
        locationSettings: LocationSettings(
            accuracy: desiredAccuracy,
            distanceFilter: distanceFilter,
            timeLimit: timeLimit));
  }
}
