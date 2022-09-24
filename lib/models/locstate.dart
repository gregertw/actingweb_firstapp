import 'dart:async';
import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:first_app/providers/geo.dart';

class LocStateModel with ChangeNotifier {
  Geo? locator;
  // Represent latest location
  Position _lastPos = Position(
      longitude: 0.0,
      latitude: 0.0,
      speed: 0.0,
      accuracy: 0.0,
      speedAccuracy: 0.0,
      altitude: 0.0,
      heading: 0.0,
      timestamp: DateTime.now());
  LocationPermission? _geoAccessStatus;
  // ignore: cancel_subscriptions
  StreamSubscription<Position>? _positionStreamSubscription;
  final Map<Position, Placemark?> _pointList = <Position, Placemark?>{};
  late bool _available;

  double get latitude => _lastPos.latitude;
  double get longitude => _lastPos.longitude;
  bool get isAvailable => _available;
  bool isPaused() {
    if (_positionStreamSubscription == null) {
      return true;
    }
    return _positionStreamSubscription!.isPaused;
  }

  List<Position> get positions => List.from(_pointList.keys);
  List<Placemark> get placemarks => List.from(_pointList.values);
  LinkedHashMap<Position, Placemark?> get pointList =>
      _pointList as LinkedHashMap<Position, Placemark?>;

  LocStateModel(this.locator) {
    _available = false;
    locator ??= Geo();
  }

  Future<bool> available() async {
    _geoAccessStatus = await locator!.checkPermission();
    if (_geoAccessStatus == LocationPermission.whileInUse ||
        _geoAccessStatus == LocationPermission.always) {
      _available = true;
      return true;
    }
    _available = false;
    return false;
  }

  bool isListening() => !(_positionStreamSubscription == null ||
      _positionStreamSubscription!.isPaused);

  void addLocation(Position pos) {
    _pointList[pos] = null;
    _lastPos = pos;
    notifyListeners();
    // The underlying flutter_geocoding plugin does not support web yet
    if (kIsWeb) {
      return;
    }
    try {
      locator!.fromCoordinates(pos.latitude, pos.longitude).then((pm) {
        _pointList[pos] = pm.first;
        notifyListeners();
      });
    } catch (e) {
      // The fromCoordinates() method uses an underlying OS API that has restrictions
      // so this request may fail and no address is added for the location.
      return;
    }
  }

  Placemark? getPlacemark(Position pos) {
    return _pointList[pos];
  }

  String getAddressString(Position pos) {
    final placemark = _pointList[pos];
    if (placemark == null) {
      return '';
    }
    final String name = placemark.name ?? '';
    final String street = placemark.thoroughfare ?? '';
    final String streetnumber = placemark.subThoroughfare ?? '';
    final String city = placemark.locality ?? '';
    final String state = placemark.administrativeArea ?? '';
    final String country = placemark.country ?? '';

    String address;
    if (state == city) {
      address = '$name, $streetnumber $street, $city, $country';
    } else {
      address = '$name, $streetnumber $street, $city, $state, $country';
    }
    return address;
  }

  void toggleListening() async {
    if (!await available()) {
      return;
    }
    if (_positionStreamSubscription == null) {
      final Stream<Position> positionStream = locator!.getPositionStream(
          desiredAccuracy: LocationAccuracy.best, distanceFilter: 0);
      _positionStreamSubscription =
          positionStream.listen((Position position) => addLocation(position));
      //_positionStreamSubscription.pause();
    } else {
      if (_positionStreamSubscription!.isPaused) {
        _positionStreamSubscription!.resume();
      } else {
        _positionStreamSubscription!.pause();
      }
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    super.dispose();
  }
}
