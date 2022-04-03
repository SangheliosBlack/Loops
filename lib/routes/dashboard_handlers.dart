import 'package:delivery/service/auth_service.dart';
import 'package:delivery/views/allow_gps_permission.dart';
import 'package:delivery/views/drawer/mas_informacion_view.dart';
import 'package:delivery/views/favorite_places_view.dart';
import 'package:delivery/views/dashboard_view.dart';
import 'package:delivery/views/login_view.dart';
import 'package:delivery/views/order_register_view.dart';
import 'package:delivery/views/orden_view.dart';
import 'package:delivery/views/drawer/settings_drawer_view.dart';
import 'package:fluro/fluro.dart';
import 'package:provider/provider.dart';

class DashBoardHandlers {
  
  static Handler allowGpsPermission = Handler(handlerFunc: (context, params) {
    final authProvider = Provider.of<AuthService>(context!);
    if (authProvider.authStatus == AuthStatus.authenticated) {
      return const AllowGpsPermissionView();
    } else {
      const LoginView();
    }
    return null;
  });
  

  static Handler dashboard = Handler(handlerFunc: (context, params) {
    final authProvider = Provider.of<AuthService>(context!);
    
    if (authProvider.authStatus == AuthStatus.authenticated) {
      return const DashboardView();
    } else {
      const LoginView();
    }
    return null;
  });

  /*HOME*/
  static Handler settings = Handler(handlerFunc: (context, params) {
    final authProvider = Provider.of<AuthService>(context!);
    if (authProvider.authStatus == AuthStatus.authenticated) {
      return const SettingsView();
    } else {
      const LoginView();
    }
    return null;
  });
  static Handler order = Handler(handlerFunc: (context, params) {
    final authProvider = Provider.of<AuthService>(context!);
    if (authProvider.authStatus == AuthStatus.authenticated) {
      return const OrderView();
    } else {
      const LoginView();
    }
    return null;
  });
  static Handler favorites = Handler(handlerFunc: (context, params) {
    final authProvider = Provider.of<AuthService>(context!);
    if (authProvider.authStatus == AuthStatus.authenticated) {
      return const FavoritePlacesView();
    } else {
      const LoginView();
    }
    return null;
  });

  static Handler info = Handler(handlerFunc: (context, params) {
    final authProvider = Provider.of<AuthService>(context!);
    if (authProvider.authStatus == AuthStatus.authenticated) {
      return const InfoView();
    } else {
      const LoginView();
    }
    return null;
  });
  static Handler orderRegister = Handler(handlerFunc: (context, params) {
    final authProvider = Provider.of<AuthService>(context!);
    if (authProvider.authStatus == AuthStatus.authenticated) {
      return const OrderRegisterView();
    } else {
      const LoginView();
    }
    return null;
  });
  
}
