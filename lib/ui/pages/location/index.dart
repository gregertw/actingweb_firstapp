import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:first_app/generated/i18n.dart';
import '../../../models/appstate.dart';

class LocationStreamWidget extends StatefulWidget {
  @override
  State<LocationStreamWidget> createState() => _LocationStreamState();
}

class _LocationStreamState extends State<LocationStreamWidget> {
  StreamSubscription<Position> _positionStreamSubscription;
  final List<Position> _positions = <Position>[];

  void _toggleListening() {
    if (_positionStreamSubscription == null) {
      const LocationOptions locationOptions =
      LocationOptions(accuracy: LocationAccuracy.best, distanceFilter: 10);
      final Stream<Position> positionStream =
      Geolocator().getPositionStream(locationOptions);
      _positionStreamSubscription = positionStream.listen(
              (Position position) => setState(() => _positions.add(position)));
      _positionStreamSubscription.pause();
    }

    setState(() {
      if (_positionStreamSubscription.isPaused) {
        _positionStreamSubscription.resume();
      } else {
        _positionStreamSubscription.pause();
      }
    });
  }

  @override
  void dispose() {
    if (_positionStreamSubscription != null) {
      _positionStreamSubscription.cancel();
      _positionStreamSubscription = null;
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<GeolocationStatus>(
        future: Geolocator().checkGeolocationPermissionStatus(),
        builder:
            (BuildContext context, AsyncSnapshot<GeolocationStatus> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          return new Flexible(child: _buildListView(context));
        });
  }

  Widget _buildListView(BuildContext context) {
    final List<Widget> listItems = <Widget>[
      ListTile(
        title: RaisedButton(
          child: _buildButtonText(),
          color: _determineButtonColor(context),
          padding: const EdgeInsets.all(8.0),
          onPressed: _toggleListening,
        ),
      )
    ];

    listItems.addAll(_positions
        .map((Position position) => PositionListItem(position))
        .toList());

    return ListView(
      children: listItems,
    );
  }

  bool _isListening() => !(_positionStreamSubscription == null ||
      _positionStreamSubscription.isPaused);

  Widget _buildButtonText() {
    return Text(_isListening() ? S.of(context).stopListening : S.of(context).startListening);
  }

  Color _determineButtonColor(BuildContext context) {
    return _isListening() ? Theme.of(context).primaryColorDark : Theme.of(context).primaryColorLight;
  }
}

class PositionListItem extends StatefulWidget {
  const PositionListItem(this._position);

  final Position _position;

  @override
  State<PositionListItem> createState() => PositionListItemState(_position);
}

class PositionListItemState extends State<PositionListItem> {
  PositionListItemState(this._position);

  final Position _position;
  String _address = '';

  @override
  Widget build(BuildContext context) {

    var appState = AppStateModel.of(context, true);
    appState.setLocation(_position.latitude, _position.longitude);

    final tiles = ListTile(
        onTap: _onTap,
        contentPadding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
        title: Text(S.of(context).latitudeLongitude(_position.latitude.toString(),
            _position.longitude.toString()),
        ),
        subtitle: Row(
          children: <Widget>[
            Icon(Icons.expand_more),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      _position.timestamp.toLocal().toString(),
                    ),
                    Text(_address),
                  ]),
            ),
          ],
        ),
    );

    return Card(
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(horizontal: 7.0, vertical: 2.0),
      child: Container(
        decoration: BoxDecoration(),
        child: tiles,
      ),
    );

  }

  Future<void> _onTap() async {
    String address = S.of(context).unknown;
    final List<Placemark> placemarks = await Geolocator()
        .placemarkFromCoordinates(_position.latitude, _position.longitude);

    if (placemarks != null && placemarks.isNotEmpty) {
      address = _buildAddressString(placemarks.first);
    }

    setState(() {
      _address = '$address';
    });
  }

  static String _buildAddressString(Placemark placemark) {
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
}
