// ignore_for_file: unnecessary_new

import 'dart:async';

import 'package:delivery/service/permission_status.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class AllowGpsPermissionView extends StatefulWidget {
  const AllowGpsPermissionView({Key? key}) : super(key: key);

  @override
  _AllowGpsPermissionViewState createState() => _AllowGpsPermissionViewState();
}

class _AllowGpsPermissionViewState extends State<AllowGpsPermissionView> {
  late Timer _timer;
  bool status = false;

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  void startTimer() {
    _timer = new Timer.periodic(
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
    final permissionProvider = Provider.of<PermissionStatusProvider>(context);
    return WillPopScope(
      onWillPop: () async => false,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              padding: const EdgeInsets.all(35),
              duration: const Duration(milliseconds: 1000),
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context)
                          .primaryColor
                          .withOpacity(status ? .0 : 0),
                      spreadRadius: 5,
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(1000),
                  border: Border.all(
                      color: status
                          ? Colors.grey.withOpacity(.1)
                          : Colors.grey.withOpacity(.0),
                      width: status ? .5 : .5)),
              child: AnimatedContainer(
                padding: const EdgeInsets.all(10),
                duration: const Duration(milliseconds: 1400),
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context)
                            .primaryColor
                            .withOpacity(status ? .005 : 0),
                        spreadRadius: 5,
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(1000),
                    border: Border.all(
                        color: status
                            ? Colors.grey.withOpacity(.1)
                            : Colors.grey.withOpacity(.0),
                        width: status ? 1 : 0)),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(1000),
                      child: Container(
                          padding: const EdgeInsets.all(50),
                          decoration: const BoxDecoration(color: Colors.white),
                          child: const Image(
                              image: AssetImage('assets/images/enable.png')))),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.gps_fixed),
                const SizedBox(width: 10),
                FittedBox(
                  child: Text('Permitir uso GPS',
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
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 35),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                      primary: const Color.fromRGBO(62, 204, 191, 1)),
                  onPressed: () async {
                    final status = await Permission.location.request();
                    if (kDebugMode) {
                      print(status);
                    }
                    accesoGPS(status, permissionProvider);
                  },
                  child: Text(
                    'Permitir',
                    style: GoogleFonts.quicksand(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  )),
            ),
            const SizedBox(height: 15),
            Container(
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.05),
                  spreadRadius: 5,
                  blurRadius: 10,
                  offset: const Offset(0, 0),
                ),
              ]),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      primary: Colors.white),
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
