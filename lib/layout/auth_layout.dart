import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthLayout extends StatelessWidget {
  final Widget child;
  const AuthLayout({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    return SafeArea(
      top: false,
      child: Scaffold(backgroundColor: Colors.white, body: child),
    );
  }
}
