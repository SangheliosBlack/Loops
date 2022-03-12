// ignore_for_file: sized_box_for_whitespace

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void calculandoAlerta(BuildContext context) {
  if (Platform.isAndroid) {
    showDialog(
        
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
              content: Container(
                height: 70,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: Theme.of(context).primaryColor,
                    ),
                  ],
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
