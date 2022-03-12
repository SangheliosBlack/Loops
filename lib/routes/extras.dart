import 'package:delivery/service/auth_service.dart';
import 'package:delivery/service/permission_status.dart';
import 'package:delivery/views/allow_gps_permission.dart';
import 'package:delivery/views/drawer/direcciones_drawer_view.dart';
import 'package:delivery/views/drawer/metodos_pago_drawer_view.dart';
import 'package:delivery/views/extras/nuevo_producto_view.dart';
import 'package:delivery/views/extras/editar_direccion.dart';
import 'package:delivery/views/gps_disable_view.dart';
import 'package:delivery/views/login_view.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class ExtrasHandlers {
  static Handler misDirecciones = Handler(handlerFunc: (context, params) {
    final authService = Provider.of<AuthService>(context!);
    final permissionService = Provider.of<PermissionStatusProvider>(context);
    if (authService.authStatus == AuthStatus.notAuthenticated) {
      return const LoginView();
    } else {
      if (permissionService.isGranted) {
        if (permissionService.isEnabled) {
          return const MisDireccionesView();
        } else {
          return const GpsDisableView();
        }
      } else {
        return const AllowGpsPermissionView();
      }
    }
  });

  static Handler editarMenu = Handler(handlerFunc: (context, params) {
    final authService = Provider.of<AuthService>(context!);
    final permissionService = Provider.of<PermissionStatusProvider>(context);
    if (authService.authStatus == AuthStatus.notAuthenticated) {
      return const LoginView();
    } else {
      if (permissionService.isGranted) {
        if (permissionService.isEnabled) {
          return Container();
        } else {
          return const GpsDisableView();
        }
      } else {
        return const AllowGpsPermissionView();
      }
    }
  });

  static Handler editarDireccion = Handler(handlerFunc: (context, params) {
    final authService = Provider.of<AuthService>(context!);
    final permissionService = Provider.of<PermissionStatusProvider>(context);
    if (authService.authStatus == AuthStatus.notAuthenticated) {
      return const LoginView();
    } else {
      if (permissionService.isGranted) {
        if (permissionService.isEnabled) {
          return EditarDireccionView(index: int.parse(params['uid']![0]));
        } else {
          return const GpsDisableView();
        }
      } else {
        return const AllowGpsPermissionView();
      }
    }
  });

  static Handler agregarTienda = Handler(handlerFunc: (context, params) {
    final authService = Provider.of<AuthService>(context!);
    final permissionService = Provider.of<PermissionStatusProvider>(context);
    if (authService.authStatus == AuthStatus.notAuthenticated) {
      return const LoginView();
    } else {
      if (permissionService.isGranted) {
        if (permissionService.isEnabled) {
          return const AgregarProductoView();
        } else {
          return const GpsDisableView();
        }
      } else {
        return const AllowGpsPermissionView();
      }
    }
  });

  
  static Handler metodosPago = Handler(handlerFunc: (context, params) {
    final authService = Provider.of<AuthService>(context!);
    final permissionService = Provider.of<PermissionStatusProvider>(context);
    if (authService.authStatus == AuthStatus.notAuthenticated) {
      return const LoginView();
    } else {
      if (permissionService.isGranted) {
        if (permissionService.isEnabled) {
          return const MetodosPagoView();
        } else {
          return const GpsDisableView();
        }
      } else {
        return const AllowGpsPermissionView();
      }
    }
  });
}
