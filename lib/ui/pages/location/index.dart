import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:first_app/generated/l10n.dart';
import 'package:first_app/models/locstate.dart';

String latitudeLongitude(String lat, String long) => "Lat: $lat, Long: $long";

class LocationStreamWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: Provider.of<LocStateModel>(context).available(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          return new Flexible(child: _buildListView(context));
        });
  }

  Widget _buildListView(BuildContext context) {
    final List<Widget> listItems = <Widget>[
      ListTile(
        title: ElevatedButton(
          key: Key('LocationPage_StartListeningButton'),
          style: ElevatedButton.styleFrom(
            elevation: 20.0,
            onPrimary: Theme.of(context).primaryColorLight,
            padding: const EdgeInsets.all(8.0),
          ),
          child: Text(Provider.of<LocStateModel>(context).isListening()
              ? S.of(context).stopListening
              : S.of(context).startListening),
          onPressed: Provider.of<LocStateModel>(context).toggleListening,
        ),
      ),
    ];

    listItems.addAll(Provider.of<LocStateModel>(context)
        .positions
        .map((Position position) => PositionListItem(position))
        .toList());

    return ListView(
      children: listItems,
    );
  }
}

class PositionListItem extends StatelessWidget {
  const PositionListItem(this._position);

  final Position _position;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.only(left: 10.0, bottom: 2.0, top: 2.0, right: 10.0),
      decoration: BoxDecoration(),
      child: Card(
        elevation: 15.0,
        margin: new EdgeInsets.symmetric(horizontal: 7.0, vertical: 7.0),
        child: Padding(
          padding: const EdgeInsets.only(
            top: 2.0,
            bottom: 2.0,
            left: 2.0,
          ),
          child: ListTile(
            key: Key('LocationPage_LocationTile'),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 15.0, vertical: 3.0),
            title: Text(
              latitudeLongitude(
                _position.latitude.toString(),
                _position.longitude.toString(),
              ),
            ),
            subtitle: Row(
              children: <Widget>[
                Icon(Icons.arrow_right),
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(Provider.of<LocStateModel>(context)
                            .getAddressString(_position)),
                      ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
