// ignore_for_file: sized_box_for_whitespace

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void mostrarCarga(BuildContext context) {
  if (Platform.isAndroid) {
    showDialog(
        barrierColor: Colors.white.withOpacity(1),
        barrierDismissible: false,
        useSafeArea: true,
        context: context,
        builder: (context) => WillPopScope(
              onWillPop: () async => false,
              child: AlertDialog(
                backgroundColor: Colors.transparent,
                elevation: 0,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0))),
                content: Container(
                  height: 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        child: const CircularProgressIndicator(
                          strokeWidth: 1,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ));
  } else {
    showCupertinoDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => const CupertinoAlertDialog(
              title: Text('Espere por favor'),
              content: CupertinoActivityIndicator(),
            ));
  }
}
