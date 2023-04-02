import 'package:delivery/service/hide_show_menu.dart';
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
        ChangeNotifierProvider(lazy: false, create: (_) => TiendaService()),
        ChangeNotifierProvider(lazy: false, create: (_) => SocioService()),
        ChangeNotifierProvider(lazy: false, create: (_) => GeneralActions()),
      ],
      child: Scaffold(
        body: Center(
          child: child,
        ),
      ),
    );
  }
}
