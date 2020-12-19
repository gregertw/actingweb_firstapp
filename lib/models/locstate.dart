import 'dart:async';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class Geo {
  Future<LocationPermission> checkPermission() async {
    return Geolocator.checkPermission();
  }

  Future<List<Placemark>> placemarkFromCoordinates(
      double latitude, double longitude,
      {String localeIdentifier}) {
    return placemarkFromCoordinates(latitude, longitude);
  }

  Stream<Position> getPositionStream(
      {LocationAccuracy desiredAccuracy = LocationAccuracy.best,
      int distanceFilter = 0,
      bool forceAndroidLocationManager = false,
      Duration intervalDuration,
      Duration timeLimit}) {
    return Geolocator.getPositionStream(
        desiredAccuracy: desiredAccuracy,
        distanceFilter: distanceFilter,
        forceAndroidLocationManager: forceAndroidLocationManager,
        intervalDuration: intervalDuration,
        timeLimit: timeLimit);
  }
}

class LocStateModel with ChangeNotifier {
  Geo locator;
  // Represent latest location
  Position _lastPos = Position(longitude: 0.0, latitude: 0.0);
  LocationPermission _geoAccessStatus;
  StreamSubscription<Position> _positionStreamSubscription;
  final Map<Position, Placemark> _pointList = Map<Position, Placemark>();

  double get latitude => _lastPos.latitude;
  double get longitude => _lastPos.longitude;
  bool isPaused() {
    if (_positionStreamSubscription == null) {
      return true;
    }
    return _positionStreamSubscription.isPaused;
  }

  List<Position> get positions => List.from(_pointList.keys);
  List<Placemark> get placemarks => List.from(_pointList.values);
  LinkedHashMap<Position, Placemark> get pointList => _pointList;

  LocStateModel(this.locator) {
    if (this.locator == null) {
      this.locator = Geo();
    }
  }

  Future<bool> available() async {
    _geoAccessStatus = await locator.checkPermission();
    if (_geoAccessStatus == LocationPermission.whileInUse ||
        _geoAccessStatus == LocationPermission.always) {
      return true;
    }
    return false;
  }

  bool isListening() => !(_positionStreamSubscription == null ||
      _positionStreamSubscription.isPaused);

  void addLocation(Position pos) {
    _pointList[pos] = null;
    _lastPos = pos;
    try {
      locator.placemarkFromCoordinates(pos.latitude, pos.longitude).then((pm) {
        if (pm != null) {
          _pointList[pos] = pm.first;
        }
        notifyListeners();
      });
    } catch (e) {
      return;
    }
    notifyListeners();
  }

  Placemark getPlacemark(Position pos) {
    if (pos == null) {
      return null;
    }
    return _pointList[pos];
  }

  String getAddressString(Position pos) {
    if (pos == null) {
      return '';
    }
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

  void toggleListening() {
    if (_positionStreamSubscription == null) {
      final Stream<Position> positionStream = locator.getPositionStream(
          desiredAccuracy: LocationAccuracy.best, distanceFilter: 10);
      _positionStreamSubscription =
          positionStream.listen((Position position) => addLocation(position));
      //_positionStreamSubscription.pause();
    } else {
      if (_positionStreamSubscription.isPaused) {
        _positionStreamSubscription.resume();
      } else {
        _positionStreamSubscription.pause();
      }
    }
    notifyListeners();
  }

  @override
  void dispose() {
    if (_positionStreamSubscription != null) {
      _positionStreamSubscription.cancel();
      _positionStreamSubscription = null;
    }
    super.dispose();
  }
}
