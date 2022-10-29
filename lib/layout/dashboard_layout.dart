import 'package:delivery/service/direcciones.service.dart';
import 'package:delivery/service/hide_show_menu.dart';
import 'package:delivery/service/llenar_pantallas.dart';
import 'package:delivery/service/navigator_service.dart';
import 'package:delivery/service/permission_status.dart';
import 'package:delivery/service/puto_dial.dart';
import 'package:delivery/service/socio_service.dart';
import 'package:delivery/service/stripe_service.dart';
import 'package:delivery/service/tarjetas.service.dart';
import 'package:delivery/service/tiendas_service.dart';
import 'package:delivery/service/ventas_service.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class DashboardLayout extends StatefulWidget {
  final Widget child;

  const DashboardLayout({Key? key, required this.child}) : super(key: key);

  @override
  _DashboardLayoutState createState() => _DashboardLayoutState();
}

class _DashboardLayoutState extends State<DashboardLayout>
    with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance?.addObserver(this);

    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      if (state == AppLifecycleState.resumed) {
        final permissionService =
            Provider.of<PermissionStatusProvider>(context, listen: false);
        permissionService.accesoGPS();
        permissionService.gpsEnabled();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(lazy: false, create: (_) => PedidosService()),
        ChangeNotifierProvider(lazy: false, create: (_) => TarjetasService()),
        ChangeNotifierProvider(lazy: false, create: (_) => StripeService()),
        ChangeNotifierProvider(
            lazy: false, create: (_) => DireccionesService()),
        ChangeNotifierProvider(
            lazy: false, create: (_) => LlenarPantallasService()),
        ChangeNotifierProvider(lazy: false, create: (_) => TiendasService()),
        ChangeNotifierProvider(lazy: false, create: (_) => GeneralActions()),
        ChangeNotifierProvider(lazy: false, create: (_) => PutoDial()),
        ChangeNotifierProvider(lazy: false, create: (_) => SocioService()),
      ],
      child: widget.child,
    );
  }

  Future<void> accesoGPS(GeneralActions generalActions) async {
    final status = await Permission.location.request();

    switch (status) {
      case PermissionStatus.granted:
        //acceso garamtizadp
        break;

      case PermissionStatus.denied:
      case PermissionStatus.restricted:
      case PermissionStatus.limited:
        break;
      case PermissionStatus.permanentlyDenied:
        navigationService.customNavigateTo(10);
        break;
    }
  }
}
