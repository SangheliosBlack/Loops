import 'dart:async';

import 'package:delivery/service/permission_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';

class GpsDisableView extends StatefulWidget {
  const GpsDisableView({Key? key}) : super(key: key);


  @override
   createState() => GpsDisableViewState();
}

class GpsDisableViewState extends State<GpsDisableView> {
  late Timer _timer;
  bool status = false;

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  void startTimer() {
    _timer = Timer.periodic(
      const Duration(seconds: 2),
      (Timer timer) {
        if (status) {
          if (mounted) {
            setState(() {
              status = false;
            });
          }
        } else {
          if (mounted) {
            setState(() {
              status = true;
            });
          }
        }
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 1400),
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context)
                          .primaryColor
                          .withOpacity(status ? .2 : 0),
                      spreadRadius: 5,
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(1000),
                  border: Border.all(
                      color: status
                          ? Theme.of(context).primaryColor.withOpacity(.3)
                          : Theme.of(context).primaryColor.withOpacity(.0),
                      width: status ? 3 : 0)),
              child: Container(
                padding: const EdgeInsets.all(10),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(1000),
                    child: Container(
                        padding: const EdgeInsets.all(50),
                        decoration: BoxDecoration(
                            color:
                                Theme.of(context).primaryColor.withOpacity(.3)),
                        child: const Image(
                            image: AssetImage('assets/images/gps.png')))),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Icon(Icons.gps_off),
                const SizedBox(width: 10),
                FittedBox(
                  child: Text('Gps desactivado',
                      style: GoogleFonts.quicksand(
                          color: Colors.black.withOpacity(.7),
                          fontSize: 32,
                          fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
                'Lorem Ipsum es simplemente el texto de relleno de las imprentas y archivos de texto.',
                textAlign: TextAlign.center,
                style: GoogleFonts.quicksand(
                    fontSize: 14,
                    color: Colors.black.withOpacity(.4),
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 15),
            Container(
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 5,
                  blurRadius: 10,
                  offset: const Offset(0, 0),
                ),
              ]),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: 0, backgroundColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15))),
                  onPressed: () async {
                    Geolocator.openLocationSettings();
                  },
                  child: Text(
                    'Activar',
                    style: GoogleFonts.quicksand(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  )),
            ),
            const SizedBox(height: 15),
            Container(
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 5,
                  blurRadius: 10,
                  offset: const Offset(0, 0),
                ),
              ]),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: 0, backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15))),
                  onPressed: () {
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  },
                  child: Text(
                    'Salir',
                    style: GoogleFonts.quicksand(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  void accesoGPS(
      PermissionStatus status, PermissionStatusProvider permissionProvider) {
    switch (status) {
      case PermissionStatus.granted:
        permissionProvider.accesoGPS();
        break;

      case PermissionStatus.denied:
      case PermissionStatus.restricted:
      case PermissionStatus.limited:
      case PermissionStatus.permanentlyDenied:
        openAppSettings();
    }
  }
}
