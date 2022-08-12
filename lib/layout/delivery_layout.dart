import 'package:flutter/material.dart';

class DeliveryLayout extends StatelessWidget {
  final Widget child;
  const DeliveryLayout({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(backgroundColor: Colors.white, body: child),
    );
  }
}
