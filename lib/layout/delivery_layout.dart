import 'package:delivery/service/repartidor_service.dart';
import 'package:delivery/service/socio_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DeliveryLayout extends StatelessWidget {
  final Widget child;
  const DeliveryLayout({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            lazy: false, create: (_) => RepartidorProvider()),
        ChangeNotifierProvider(lazy: false, create: (_) => SocioService()),
      ],
      child: SafeArea(
        top: false,
        child: Scaffold(backgroundColor: Colors.white, body: child),
      ),
    );
  }
}
