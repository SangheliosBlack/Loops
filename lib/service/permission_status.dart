import 'dart:convert';

import 'package:delivery/global/enviroment.dart';
import 'package:delivery/models/geocoding_reverse.dart';
import 'package:delivery/service/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

class PermissionStatusProvider with ChangeNotifier {
  List<Result> listaSugerencias = [];

  late Position currentLocation;

  /*PERMISSION REQUEST*/
  bool _isGranted = false;

  bool get isGranted => _isGranted;

  set isGranted(bool state) {
    _isGranted = state;
    notifyListeners();
  }
  /*PERMISSION REQUEST*/

  /*GPS ENABLED*/
  bool _isEnabled = false;

  bool get isEnabled => _isEnabled;

  set isEnabled(bool state) {
    _isEnabled = state;
    notifyListeners();
  }

  /*GPS ENABLED*/

  PermissionStatusProvider() {
    accesoGPS();
    gpsEnabled();
  }

  Future<void> accesoGPS() async {
    final status = await Permission.location.status;
    switch (status) {
      case PermissionStatus.granted:
        isGranted = true;
        break;

      case PermissionStatus.denied:
      case PermissionStatus.restricted:
      case PermissionStatus.limited:
        isGranted = false;
        break;
      case PermissionStatus.permanentlyDenied:
        isGranted = false;
        break;
    }
  }

  Future<void> gpsEnabled() async {
    final gpsEnabled = await Geolocator.isLocationServiceEnabled();
    if (gpsEnabled) {
      isEnabled = true;
    } else {
      isEnabled = false;
    }
  }

  Future<void> ubicacionActual() async {
    Position posicion = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);

    currentLocation = posicion;
    final data = {'coordenadas': '${posicion.latitude},${posicion.longitude}'};

    try {
      final resp = await http.post(
          Uri.parse('${Statics.apiUrl}/google/sugerencia'),
          body: jsonEncode(data),
          headers: {
            'Content-Type': 'application/json',
            'x-token': await AuthService.getToken()
          });

      final searchResponse = geodingReverseFromJson(resp.body);
      listaSugerencias = searchResponse.results;
      notifyListeners();
      // ignore: empty_catches
    } catch (e) {
    }
  }
}
