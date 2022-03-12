import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'
    show BitmapDescriptor;

Future<BitmapDescriptor> getAssetImageMarker() async {
  return BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(devicePixelRatio: 2.5), 'assets/position.svg');
}
