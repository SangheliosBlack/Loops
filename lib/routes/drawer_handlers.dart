

import 'package:delivery/service/auth_service.dart';
import 'package:delivery/views/drawer/direcciones_drawer_view.dart';
import 'package:delivery/views/drawer/info_venta_drawer_view.dart';
import 'package:delivery/views/drawer/mas_informacion_view.dart';
import 'package:delivery/views/drawer/metodos_pago_drawer_view.dart';
import 'package:delivery/views/drawer/mis_pedidos_drawer_view.dart';
import 'package:delivery/views/login_view.dart';
import 'package:fluro/fluro.dart';
import 'package:provider/provider.dart';

class DrawerHandlers {
  static Handler metodosPago = Handler(handlerFunc: (context, params) {
    final authProvider = Provider.of<AuthService>(context!);
    if (authProvider.authStatus == AuthStatus.authenticated) {
      return const MetodosPagoView();
    } else {
      return const LoginView();
    }
  });
  static Handler direcciones = Handler(handlerFunc: (context, params) {
    final authProvider = Provider.of<AuthService>(context!);
    if (authProvider.authStatus == AuthStatus.authenticated) {
      return const MisDireccionesView();
    } else {
      return const LoginView();
    }
  });
  static Handler pedidos = Handler(handlerFunc: (context, params) {
    final authProvider = Provider.of<AuthService>(context!);
    if (authProvider.authStatus == AuthStatus.authenticated) {
      return const MisPedidosView();
    } else {
      return const LoginView();
    }
  });
  static Handler infoVenta = Handler(handlerFunc: (context, params) {
    final authProvider = Provider.of<AuthService>(context!);
    if (authProvider.authStatus == AuthStatus.authenticated) {
      return const InfoVendedoresView();
    } else {
      return const LoginView();
    }
  });
  static Handler info = Handler(handlerFunc: (context, params) {
    final authProvider = Provider.of<AuthService>(context!);
    if (authProvider.authStatus == AuthStatus.authenticated) {
      return const InfoView();
    } else {
      return const LoginView();
    }
  });
}
