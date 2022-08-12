import 'package:delivery/service/bluetooth_servide.dart';
import 'package:delivery/service/socio_service.dart';
import 'package:delivery/service/tiendas_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SocioLayout extends StatelessWidget {
  final Widget child;
  const SocioLayout({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(lazy: false, create: (_) => BluetoothProvider()),
        ChangeNotifierProvider(lazy: false, create: (_) => TiendasService()),
        ChangeNotifierProvider(lazy: false, create: (_) => SocioService()),
      ],
      child: Scaffold(
        body: Center(
          child: child,
        ),
      ),
    );
  }
}
