import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:first_app/ui/widgets/anchored_overlay.dart';
import 'package:first_app/models/locstate.dart';

class OverlayMapPage extends StatefulWidget {
  const OverlayMapPage({Key? key}) : super(key: key);

  @override
  _OverlayMapPageState createState() => _OverlayMapPageState();
}

class _OverlayMapPageState extends State<OverlayMapPage> {
  final Completer<GoogleMapController> _controller = Completer();
  Set<Marker>? _markers;
  // If you want to record the position when the user moves the map, see the GoogleMap widget below
  //CameraPosition _current;
  late MapType _mapType;
  bool? _show;
  double _lat = 0.0, _lon = 0.0;

  @override
  void initState() {
    super.initState();
    _show = false;
    _markers = <Marker>{};
    _mapType = MapType.normal;
  }

  @override
  Widget build(BuildContext context) {
    final lat = Provider.of<LocStateModel>(context).latitude;
    final lon = Provider.of<LocStateModel>(context).longitude;

    if (_lat != lat || _lon != lon) {
      _lat = lat;
      _lon = lon;
      _markers = {
        Marker(
            markerId: const MarkerId("Current"),
            infoWindow: const InfoWindow(
                title: "Current position",
                snippet: "The most recent position received."),
            position: LatLng(_lat, _lon),
            icon: BitmapDescriptor.defaultMarkerWithHue(2.0))
      };
      _updatePosition();
    }

    return AnchoredOverlay(
      showOverlay: _show,
      overlayBuilder: (context, offset) {
        return CenterAbout(
          position: Offset(offset.dx, offset.dy - 150),
          child: Container(
            width: 300.0,
            height: 200.0,
            constraints:
                const BoxConstraints(maxHeight: 300.0, maxWidth: 400.0),
            decoration: const BoxDecoration(),
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(_lat, _lon),
                zoom: 16.0,
              ),
              mapType: _mapType,
              onMapCreated: (GoogleMapController controller) {
                if (!_controller.isCompleted) {
                  _controller.complete(controller);
                }
              },
              markers: _markers!,
              // If we want to capture a moved position, we can use a callback
              //onCameraMove: (CameraPosition pos) {
              //  _current = pos;  // _current must also be declared at the top
              //},
            ),
          ),
        );
      },
      child: FloatingActionButton(
        key: const Key('OverlayMap_ToggleButton'),
        onPressed: () {
          setState(() {
            _show = !_show!;
          });
        },
        child: const Icon(Icons.map),
      ),
    );
  }

  Future<void> _updatePosition() async {
    if (_show!) {
      final GoogleMapController controller = await _controller.future;
      controller
          .animateCamera(CameraUpdate.newLatLngZoom(LatLng(_lat, _lon), 16.0));
    }
  }
}
