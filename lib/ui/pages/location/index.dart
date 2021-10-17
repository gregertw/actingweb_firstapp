import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:first_app/models/locstate.dart';

String latitudeLongitude(String lat, String long) => "Lat: $lat, Long: $long";

class LocationStreamWidget extends StatelessWidget {
  const LocationStreamWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: Provider.of<LocStateModel>(context).available(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          return Flexible(child: _buildListView(context));
        });
  }

  Widget _buildListView(BuildContext context) {
    final List<Widget> listItems = <Widget>[
      ListTile(
        title: ElevatedButton(
          key: const Key('LocationPage_StartListeningButton'),
          style: ElevatedButton.styleFrom(
            elevation: 20.0,
            onPrimary: Theme.of(context).primaryColorLight,
            padding: const EdgeInsets.all(8.0),
          ),
          child: Text(Provider.of<LocStateModel>(context).isListening()
              ? AppLocalizations.of(context)!.stopListening
              : AppLocalizations.of(context)!.startListening),
          onPressed: Provider.of<LocStateModel>(context).toggleListening,
        ),
      ),
    ];

    listItems.addAll(Provider.of<LocStateModel>(context)
        .positions
        .map((Position position) => PositionListItem(position: position))
        .toList());

    return ListView(
      children: listItems,
    );
  }
}

class PositionListItem extends StatelessWidget {
  final Position position;
  const PositionListItem({Key? key, required this.position}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.only(left: 10.0, bottom: 2.0, top: 2.0, right: 10.0),
      decoration: const BoxDecoration(),
      child: Card(
        elevation: 15.0,
        margin: const EdgeInsets.symmetric(horizontal: 7.0, vertical: 7.0),
        child: Padding(
          padding: const EdgeInsets.only(
            top: 2.0,
            bottom: 2.0,
            left: 2.0,
          ),
          child: ListTile(
            key: const Key('LocationPage_LocationTile'),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 3.0),
            title: Text(
              latitudeLongitude(
                position.latitude.toString(),
                position.longitude.toString(),
              ),
            ),
            subtitle: Row(
              children: <Widget>[
                const Icon(Icons.arrow_right),
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(Provider.of<LocStateModel>(context)
                            .getAddressString(position)),
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
