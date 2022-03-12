// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';

class SplashLayout extends StatelessWidget {
  const SplashLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                width: 50,
                height: 50,
                child: const FlutterLogo(
                  size: 150,
                )),
            
          ],
        ),
      ),
    );
  }
}
