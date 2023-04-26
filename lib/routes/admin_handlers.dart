import 'package:delivery/service/auth_service.dart';
import 'package:delivery/service/permission_status.dart';
import 'package:delivery/service/socket_service.dart';
import 'package:delivery/views/admin/admin_dasboard.dart';
import 'package:delivery/views/allow_gps_permission.dart';
import 'package:delivery/views/autentificar_celular.dart';
import 'package:delivery/views/confirmar_codigo.dart';
import 'package:delivery/views/dashboard_view.dart';
import 'package:delivery/views/delivery/dashboard.dart';
import 'package:delivery/views/extras/loading_view.dart';
import 'package:delivery/views/gps_disable_view.dart';
import 'package:delivery/views/punto_venta/punto_venta_main.dart';
import 'package:delivery/views/register_view.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

class AdminHandlers {
  static Handler login = Handler(handlerFunc: (context, params) {
    final authService = Provider.of<AuthService>(context!);
    final permissionService = Provider.of<PermissionStatusProvider>(context);
    final socketService = Provider.of<SocketService>(context);


    if (authService.puntoVentaStatus == PuntoVenta.isAvailable) {
      if (socketService.serverStatus == ServerStatus.Online) {
        return const PuntoVentaMainView();
      } else {
        return const LoadingView();
      }
    }

    if (authService.authStatus == AuthStatus.notAuthenticated) {
      return const AutentificarCelular();
    } else {
      if (kIsWeb) {
        if (authService.usuario.numeroCelular == '4741030509') {
          return const AdminDashBoard();
        } else {
          return const DashboardView();
        }
      }
      if (permissionService.isGranted) {
        if (permissionService.isEnabled) {
          if (authService.usuario.repartidor && authService.usuario.hibrido) {
            return const DashBoardViewRepartidor();
          } else {
            return const DashboardView();
          }
        } else {
          return const GpsDisableView();
        }
      } else {
        return const AllowGpsPermissionView();
      }
    }
  });
  static Handler autentificarPhone = Handler(handlerFunc: (context, params) {
    final authService = Provider.of<AuthService>(context!);
    final permissionService = Provider.of<PermissionStatusProvider>(context);
    if (authService.authStatus == AuthStatus.notAuthenticated) {
      /* return const LoginView();*/
      return const AutentificarCelular();
    } else {
      if (permissionService.isGranted) {
        if (permissionService.isEnabled) {
          return const DashboardView();
        } else {
          return const GpsDisableView();
        }
      } else {
        return const AllowGpsPermissionView();
      }
    }
  });
  static Handler confirmarPhone = Handler(handlerFunc: (context, params) {
    final authService = Provider.of<AuthService>(context!);
    final permissionService = Provider.of<PermissionStatusProvider>(context);
    if (authService.authStatus == AuthStatus.notAuthenticated) {
      return ConfirmarCodigo(
        numero: params['numero']![0],
        codigo: params['codigo']![0],
      );
    } else {
      if (permissionService.isGranted) {
        if (permissionService.isEnabled) {
          return const DashboardView();
        } else {
          return const GpsDisableView();
        }
      } else {
        return const AllowGpsPermissionView();
      }
    }
  });

  static Handler register = Handler(handlerFunc: (context, params) {
    final authService = Provider.of<AuthService>(context!);
    if (authService.authStatus == AuthStatus.notAuthenticated) {
      return RegisterView(
        numero: params['numero']![0],
        dialCode: params['dialCode']![0],
      );
    } else {
      return const DashboardView();
    }
  });
}
