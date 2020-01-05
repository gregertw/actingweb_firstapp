import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:first_app/ui/widgets/anchored_overlay.dart';
import 'package:first_app/models/appstate.dart';

class OverlayMapPage extends StatefulWidget {
  @override
  _OverlayMapPageState createState() => _OverlayMapPageState();
}

class _OverlayMapPageState extends State<OverlayMapPage> {
  GoogleMapController _controller;
  Set<Marker> _markers;
  CameraPosition _current;
  MapType _mapType;
  bool _show;
  double _lat = 0.0, _lon = 0.0;

  @override
  void initState() {
    super.initState();
    _show = false;
    _markers = null;
    _mapType = MapType.normal;
  }

  @override
  Widget build(BuildContext context) {
    final lat = AppStateModel.of(context, false).latitude;
    final lon = AppStateModel.of(context, false).longitude;

    if (_lat != lat || _lon != lon) {
      _lat = lat;
      _lon = lon;
      _markers = Set.from([
        Marker(
            markerId: MarkerId("Current"),
            infoWindow: InfoWindow(
                title: "Current position",
                snippet: "The most recent position received."),
            position: LatLng(_lat, _lon),
            icon: BitmapDescriptor.defaultMarkerWithHue(2.0))
      ]);
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
            constraints: BoxConstraints(maxHeight: 300.0, maxWidth: 400.0),
            decoration: BoxDecoration(),
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(_lat, _lon),
                zoom: 16.0,
              ),
              mapType: _mapType,
              onMapCreated: (GoogleMapController controller) {
                _controller = controller;
              },
              markers: _markers,
              onCameraMove: (CameraPosition pos) {
                _current = pos;
              },
            ),
          ),
        );
      },
      child: FloatingActionButton(
        onPressed: () {
          setState(() {
            _show = !_show;
          });
        },
        child: Icon(Icons.map),
      ),
    );
  }

  Future<void> _updatePosition() async {
    if (_controller != null && _show) {
      _controller
          .animateCamera(CameraUpdate.newLatLngZoom(LatLng(_lat, _lon), 16.0));
    }
  }
}
