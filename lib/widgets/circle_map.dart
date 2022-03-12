import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CircleMap extends StatefulWidget {
  final double latitud;
  final double longitud;

  const CircleMap({Key? key, required this.latitud, required this.longitud})
      : super(key: key);

  @override
  _CircleMapState createState() => _CircleMapState();
}

class _CircleMapState extends State<CircleMap> {
  @override
  Widget build(BuildContext context) {
    final cameraPosition = CameraPosition(
        zoom: 14, target: LatLng(widget.latitud, widget.longitud));

    return ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: SizedBox(
        width: 60,
        height: 60,
        child: GoogleMap(
          padding: const EdgeInsets.all(100),
          scrollGesturesEnabled: false,
          initialCameraPosition: cameraPosition,
          myLocationEnabled: false,
          onMapCreated: (GoogleMapController controller) {
            setState(() {});
          },
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          onCameraMove: (cameraPosition) {},
        ),
      ),
    );
  }
}
