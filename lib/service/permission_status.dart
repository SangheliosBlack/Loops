import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionStatusProvider with ChangeNotifier {
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
}
